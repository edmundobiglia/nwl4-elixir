defmodule Rocketpay.Users.CreateTest do
  # DataCase é um outro módulo que por baixo dos panos usa o ExUnit (framework de testes do Elixir);
  # expõe a função errors_on() que verifica se há erros em um mapa
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  # vamos testar a função call do módulo create
  # de forma que, quando os parâmetros são válidos,
  # retorno um usuário e, quando inválidos, retorno um erro
  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Ana Biglia",
        age: 61,
        email: "annabiglia1@banana.com",
        password: "123456",
        nickname: "anabiglia123"
      }

      # fazemos pattern matching para confirmar o formato
      # do resultado devolvido e também expor o id
      {:ok, %User{id: user_id}} = Create.call(params)

      # tentamos obter o usuário criado do banco de dados
      user = Repo.get(User, user_id)

      # fazemos pattern matching para confirmar que o usuário obtido
      # CORRESPONDE aos dados do usuário que criamos.
      # IMPORTANTE: o pin operator (^) fixa o valor em vez de expor
      # uma variável.
      assert %User{name: "Ana Biglia", age: 61, id: ^user_id} = user
    end

    test "when params are invalid, returns an an error" do
      params = %{
        name: "Alexandra Biglia",
        age: 15,
        email: "xandabiglia@gmail.com",
        nickname: "xandabiglia"
      }

      # fazemos pattern matching para confirmar o formato
      # do resultado devolvido, que deve ser {:error, changeset}
      {:error, changeset} = Create.call(params)

      # pegamos o erro que é gerado neste caso e o usamos como expected response
      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      # errors on confirma que o changeset contém os erros de expected_response
      assert errors_on(changeset) == expected_response
    end
  end
end
