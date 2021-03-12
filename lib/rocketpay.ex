defmodule Rocketpay do
  # criamos um alias dando um apelido para o último método
  alias Rocketpay.Users.Create, as: UserCreate
  alias Rocketpay.Accounts.{Deposit, Withdraw, Transaction}

  # sei que tenho um módulo Rocketpay com várias funcionalidades
  # para não ter que ficar encadeando, faço este aliasing abaixo
  # permitindo usar Rocketpay.create_user(params), que já vai chamar
  # Rocketpay.Users.Create.call(params)
  defdelegate create_user(params), to: UserCreate, as: :call

  defdelegate deposit(params), to: Deposit, as: :call

  defdelegate withdraw(params), to: Withdraw, as: :call

  defdelegate transaction(params), to: Transaction, as: :call
end
