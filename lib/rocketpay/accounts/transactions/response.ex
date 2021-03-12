defmodule Rocketpay.Accounts.Transactions.Response do
  alias Rocketpay.Account

  defstruct [:from_account, :to_account]

  # criamos uma função para construir nossa structure
  def build(%Account{} = from_account, %Account{} = to_account) do
    ## %__MODULE__ representa o nome do módulo atual
    %__MODULE__{
      from_account: from_account,
      to_account: to_account
    }
  end
end
