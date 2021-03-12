defmodule RocketpayWeb.Router do
  use RocketpayWeb, :router

  # este módulo é padrão do Phoenix que oferece
  # autenticação básica com UM ÚNICO USUÁRIO
  import Plug.BasicAuth

  pipeline :api do
    # este plug determina o formato JSON como forma de comunicação
    plug :accepts, ["json"]
  end

  pipeline :auth do
    # plug de autenticação básica do Phoenix;
    # Application.compile_env(...) vai ler, no tempo de compilação,
    # os valores de username e password que definimos em config.ex
    # e criar a configuração do plug basic_auth
    plug :basic_auth, Application.compile_env(:rocketpay, :basic_auth)
  end

  scope "/api", RocketpayWeb do
    # este pipe_through basicamente "informa" ao Phoenix que
    # todas as rotas deste escopo tem que passar pelo pipeline
    # :api, ou seja, serão interceptadas pelos plugs no pipeline
    # :api, ou seja, geralmente as requisições/respostas dessa
    # rota serão transformadas pelas lógica nos plugs do pipeline :api
    pipe_through :api

    get "/:filename", WelcomeController, :index

    post "/users", UsersController, :create
  end

  scope "/api", RocketpayWeb do
    # todas as rotas nesse escopo vão ocorrer através de JSON (:api)
    # e são rotas autenticadas (:basic_auth)
    pipe_through [:api, :auth]

    post "/accounts/:id/deposit", AccountsController, :deposit
    post "/accounts/:id/withdraw", AccountsController, :withdraw
    post "/accounts/transaction", AccountsController, :transaction
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: RocketpayWeb.Telemetry
    end
  end
end
