# O teste de um módulo tem o mesmo nome, mas Test no final
defmodule Rocketpay.NumbersTest do
  # Define que se trata de um teste
  use ExUnit.Case, async: true

  alias Rocketpay.Numbers

  # indicamos a função que será testada e sua aridade
  describe "sum_from_file/1" do
    # descrição do teste
    test "when a file is provided, a sum is returned" do
      response = Numbers.sum_from_file("numbers")

      expected_response = {:ok, %{result: 37}}
      # verificar se retorno da função bate com o retorno correto esperado
      assert response == expected_response
    end

    test "when a file is not provided, an error is returned" do
      response = Numbers.sum_from_file("banana")

      expected_response = {:error, %{message: "Invalid file!"}}

      # verificar se retorno da função bate com o retorno correto esperado
      assert response == expected_response
    end
  end
end
