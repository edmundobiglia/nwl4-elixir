defmodule RocketpayWeb.UsersView do
  alias Rocketpay.{Account, User}

  def render("create.json", %{
        user: %User{
          account: %Account{id: account_id, balance: balance},
          id: id,
          name: name,
          nickname: nickname
        }
      }) do
    %{
      message: "User created",
      user: %{
        id: id,
        name: name,
        nickname: nickname,
        account: %{
          account_id: account_id,
          balance: balance
        }
      }
    }
  end
end
