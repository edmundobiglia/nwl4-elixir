defmodule Rocketpay.Users.Create do
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo, User}

  def call(params) do
    # Iniciar uma multioperação
    Multi.new()
    # O Multi.insert tem dois parâmetros: nome da operação e os dados a inserir;
    # Inserimos o changeset com os dados do usuário
    |> Multi.insert(:create_user, User.changeset(params))
    # Multi.run permite executar uma operação do Repo com o re  sultado da operação anterior;
    # Os parâmetros de run são
    # nome da operação, função em que:
    ## 1o. arg. é o Repo
    ## 2o. arg é o registro criado na operação enterior)
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      insert_account(repo, user)
    end)
    |> Multi.run(:preload_data, fn repo, %{create_user: user} ->
      preload_data(repo, user)
    end)
    |> run_transaction()
  end

  # helper que insere a conta no DB
  defp insert_account(repo, user) do
    user.id
    |> account_changeset()
    |> repo.insert()
  end

  # helper que gera e retorna o changeset de conta
  defp account_changeset(user_id) do
    params = %{user_id: user_id, balance: "0.00"}

    Account.changeset(params)
  end

  # fn para que o retorno da operação multi
  # seja o usuário completo com os dados da conta incluídos
  defp preload_data(repo, user) do
    {:ok, repo.preload(user, :account)}
  end

  # helper que finalmente execulta o Multi
  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{preload_data: user}} -> {:ok, user}
    end
  end
end
