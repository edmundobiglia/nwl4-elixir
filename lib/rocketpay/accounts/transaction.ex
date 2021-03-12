defmodule Rocketpay.Accounts.Transaction do
  alias Ecto.Multi

  alias Rocketpay.Accounts.Operation
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse
  alias Rocketpay.Repo

  def call(%{"from" => from_id, "to" => to_id, "value" => value}) do
    # Para evitar situações como, fazemos o saque e o servidor cai,
    # e o saque foi feito, mas o depósito não foi feito em seguida,
    # temos que fazer as duas transações em uma única chamada. Para
    # isso, usamos o Multi.merge() para unir a operção de saque e
    # depósito.

    # Estas duas próximas linhas são porque o alias do retorno
    # do Multi tem que ser dinâmico porque senão o Multi.merge
    # dá um erro porque não pode rastrear as operações e seus
    # retornos se tiverem o mesmo nome, então o nome tem que ser diferente
    # para depósito e saque. Por isso criamos a função build_params
    withdraw_params = build_params(from_id, value)

    deposit_params = build_params(to_id, value)

    Multi.new()
    |> Multi.merge(fn _changes ->
      Operation.call(withdraw_params, :withdraw)
    end)
    |> Multi.merge(fn _changes ->
      Operation.call(deposit_params, :deposit)
    end)
    |> run_transaction()
  end

  defp build_params(id, value), do: %{"id" => id, "value" => value}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} ->
        {:error, reason}

      # aqui inspecionamos primeiro para ver como era o retorno de
      # transaction(multi) e era withdraw: com a conta de saque
      # e deposit: com a conta de depósito, então pegamos as duas
      # contas e retornamos
      {:ok, %{deposit: to_account, withdraw: from_account}} ->
        {:ok, TransactionResponse.build(from_account, to_account)}
    end
  end
end
