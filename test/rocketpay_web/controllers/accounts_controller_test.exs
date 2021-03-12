defmodule RocketpayWeb.AccountsControllerTest do
  # RocketpayWeb.ConnCase is used for controller testing
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    # em setup vamos criar os dados que serão necessários
    # para testar o controller
    setup %{conn: conn} do
      params = %{
        name: "Rafael Camarda",
        age: 27,
        email: "rafael@banana.com",
        password: "123456",
        nickname: "rafael_camarda"
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      # aqui incluímos a autenticação no header com a chave "authorization"
      # e o valor tem que ser Basic banana:nanica123, PORÉM codificado em base 64
      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      # devolvemos os parâmetros que vamos usar no teste em si
      {:ok, conn: conn, account_id: account_id}
    end

    # test recebe como segundo argumento o retorno da função setup
    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{value: "50.00"}

      response =
        conn
        # para simular a requisição post na rota /accounts/:id/deposit usamos:
        # post(Routes.accounts_path(conn, :action_que_quero_chamar, params_enviados_via_url, corpo_da_req))
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        # espero um json com status OK (200)
        |> json_response(:ok)

      assert %{
               # como o id muda em cada execução do teste, ignoramos ele com o underline
               "account" => %{"balance" => "50.00", "id" => _id},
               "message" => "Balance changed successfully"
             } = response
    end

    test "when there are invalid params, returns en error", %{conn: conn, account_id: account_id} do
      # neste caso passamos um parâmetro inválido
      params = %{value: "banana"}

      response =
        conn
        # para simular a requisição post na rota /accounts/:id/deposit usamos:
        # post(Routes.accounts_path(conn, :action_que_quero_chamar, params_enviados_via_url, corpo_da_req))
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        # espero um json com status OK (200)
        |> json_response(:bad_request)

      # resposta será um erro neste caso
      expected_response = %{"message" => "Invalid deposit value!"}

      assert expected_response == response
    end
  end
end
