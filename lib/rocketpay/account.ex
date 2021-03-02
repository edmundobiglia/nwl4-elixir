defmodule Rocketpay.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rocketpay.User

  @primary_key {:id, :binary_id, autogenerate: true}

  # define a chave estrangeira como sendo o binary_id do usuário;
  # isto já lida com a linha "belongs_to :user, User"
  @foreign_key_type :binary_id

  @required_params [:balance, :user_id]

  schema "accounts" do
    field :balance, :decimal
    # Chave estrangeira
    belongs_to :user, User

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)

    # validar a constraint definida na migration
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
