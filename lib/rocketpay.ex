defmodule Rocketpay do
  # criamos um alias dando um apelido para o último método
  alias Rocketpay.Users.Create, as: UserCreate

  # sei que tenho um módulo Rocketpay com várias funcionalidades
  # para não ter que ficar encadeando, faço este aliasing abaixo
  # permitindo usar Rocketpay.create_user(params), que já vai chamar
  # Rocketpay.Users.Create.call(params)
  defdelegate create_user(params), to: UserCreate, as: :call
end
