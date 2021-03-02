defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    # as duas saídas possível para File.read(...) são:

    # > um tuple com {:ok, conteúdo_do_arquivo} OU
    # > um tuple com {:error, :tipo_de_erro}
    "#{filename}.csv"
    |> File.read()
    |> handle_file()
  end

  # aqui usamos pattern matching para determinar o retorno

  # se o argumento detectado corresponder a {:ok, algum_conteúdo} será avaliado:
  defp handle_file({:ok, result}) do
    result =
      result
      |> String.split(",")
      |> Stream.map(fn str -> String.to_integer(str) end)
      |> Enum.sum()

    {:ok, %{result: result}}
  end

  # se o argumento detectado corresponder a {:error, :tipo_de_erro} será avaliado:
  defp handle_file({:error, _reason}), do: {:error, %{message: "Invalid file!"}}
end
