defmodule RocketpayWeb.UsersViewTest do
  # async true roda os testes em paralelo para acelerar o tempo de resposta dos testes
  use RocketpayWeb.ConnCase, async: true

  # para testar métodos render
  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.UsersView

  test "renders create.json" do
    params = %{
      name: "Ana Biglia",
      age: 61,
      email: "annabiglia1@banana.com",
      password: "123456",
      nickname: "anabiglia123"
    }

    # fazemos pattern matching para confirmar o formato
    # do resultado devolvido e também expor o id
    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        id: user_id,
        name: "Ana Biglia",
        nickname: "anabiglia123",
        account: %{
          id: account_id,
          balance: Decimal.new("0.00")
        }
      }
    }

    assert expected_response == response
  end
end
