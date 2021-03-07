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

  # O changeset tem duas formas de trabalhar:
  # com um changeset de criação, que sempre parto de uma struct vazia (%__MODULE__{})
  # ou um changeset de update, que não começa com uma struct vazia, mas com uma struct
  # já preenchida e o cast só fará cast daquilo que muda. \\ define o argumento default,
  # ou seja, se não for passada uma struct, usar uma struct vazia %__MODULE__{} (vai entender)
  # que é para criação.
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)

    # validar a constraint definida na migration
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
