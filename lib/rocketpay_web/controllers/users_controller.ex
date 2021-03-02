defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User

  action_fallback RocketpayWeb.FallbackController

  def create(conn, params) do
    # with é como um switch no JS
    # se o retorno de Rocketpay.create_user(params) for {:ok, %User{} = user}
    # então pegue conn, passe o status etc.
    # caso contrário, devolver o retorno para o Phoenix aplicar o controller de fallback
    with {:ok, %User{} = user} <- Rocketpay.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
