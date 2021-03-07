defmodule Rocketpay.Accounts.Deposit do
  alias Ecto.Multi

  alias Rocketpay.{Account, Repo}

  # fazer pattern match para expor o ID
  def call(%{"id" => id, "value" => value}) do
    Multi.new()
    # Primeiro obtemos a conta existente a ser atualizada
    # (os argumentos são (:alias_do_retorno, função para obter a conta));
    # esta linha retornará a conta encontrada (ou erro)
    |> Multi.run(:account, fn repo, _changes -> get_account(repo, id) end)

    # Args. de run: alias do retorno e função;
    # na função, o segundo argumento é a conta retornada da linha anterior!
    |> Multi.run(:update_balance, fn repo, %{account: account} ->
      update_balance(repo, account, value)
    end)
    |> run_transaction()
  end

  defp get_account(repo, id) do
    # Argumentos de Repo.get():
    ## - entidade (neste caso, Account)
    ## - ID da identidade específica
    case repo.get(Account, id) do
      # Se retornado nulo
      nil -> {:error, "Account not found!"}
      # Se encontrou a conta, retornar a conta
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value) do
    account
    |> sum_values(value)
    |> update_account(repo, account)
  end

  defp sum_values(%Account{balance: balance}, value) do
    value
    # converte para decimal se for um número válido,
    # caso contrário, emite erro
    |> Decimal.cast()

    # l lida com o cast e retorna ou erro ou a soma
    |> handle_cast(balance)
  end

  # lida com o processo de cast considerando os dois casos: erro e sucesso;
  # em caso de sucesso, retorna a struct Decimal com o valor somado
  defp handle_cast({:ok, value}, balance), do: Decimal.add(value, balance)
  defp handle_cast(:error, _balance), do: {:error, "Invalid deposit value"}

  defp update_account({:error, _reason} = error, _repo, _account), do: error

  defp update_account(value, repo, account) do
    # criar o parâmetro para ser passado ao changeset
    # para criar o changeset
    params = %{balance: value}

    account

    # cria o changeset e passa para repo.update;
    # como uma conta existente está sendo passada
    # como primeiro argumento, changeset vai criar
    # um Changeset com o ID existente e o novo balance
    # e depois vai atualizar com repo.update()
    |> Account.changeset(params)
    |> repo.update()
  end

  # executar transação final considerando possíveis casos
  ## - Se Repo.transaction(multi) retornar {:ok ...} com
  ##   a conta atualizada, retornar {:ok, account}
  ## - Se retornar erro, retorna o erro
  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_balance: account}} -> {:ok, account}
    end
  end
end
