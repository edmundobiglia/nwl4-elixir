defmodule RocketpayWeb.WelcomeController do
  # indica que este módulo é um controller
  use RocketpayWeb, :controller

  # conn = conexão
  # segundo argumento são os parâmetros

  # alias permite agora usar só Numbers em vez de Rocketpay.Numbers
  alias Rocketpay.Numbers

  # os parâmetros da requisição vêm na forma de um map
  # em que "filename" é o nome do arquivo passado;
  # abaixo fazemos pattern matching armazenando o nome
  # do arquivo em uma variável filename
  def index(conn, %{"filename" => filename}) do
    filename
    |> Numbers.sum_from_file()
    |> handle_response(conn)
  end

  defp handle_response({:ok, %{result: result}}, conn) do
    conn
    |> put_status(:ok)
    |> json(%{message: "Welcome to the Rocketpay API. Here is your number: #{result}"})
  end

  defp handle_response({:error, reason}, conn) do
    conn
    |> put_status(:bad_request)
    |> json(reason)
  end
end
