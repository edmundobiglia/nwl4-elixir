defmodule Rocketpay.User do
  # as linhas abaixo use e import estamos trazendo
  # as funcionalidades do Ecto para este módulo

  # define que é um schema
  use Ecto.Schema
  import Ecto.Changeset

  alias Rocketpay.Account
  alias Ecto.Changeset

  # variavel de módulo (+ou- como const)
  # campo id gerado autom. pelo Ecto, :binary_id determina que é UUID
  @primary_key {:id, :binary_id, autogenerate: true}

  # lista de parâmetros obrigatórios para validação posterior em changeset
  @required_params [:name, :age, :email, :password, :nickname]

  # p/ definir o schema: schema nome_da_tabela
  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    # virtual porque este campo existe no schema mas não no db
    # o que será gravado no db é password_hash, não password
    field :password, :string, virtual: true
    field :password_hash, :string
    field :nickname, :string
    has_one :account, Account

    timestamps()
  end

  # esta função é responsável por mapear os dados de input
  # para os campos da tabela e também por validar os dados;
  # há vários tipos de validações
  def changeset(params) do
    # %__MODULE__{} é uma struct (mapa nomeado) Changeset vazia e "cast" adiciona
    # os dados nela e depois vai validando esse mapa e retornando-o em cada etapa
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
    |> unique_constraint([:nickname])
    |> put_password_hash()
  end

  # se o changeset recebido for válido, vamos criptografar a senha
  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    # change recebe um changeset e o modifica;
    # a função Bcrypt.add_hash retorna um mapa assim %{password_hash: "sakdfjslaf8343209j"};
    # a função change adiciona essa propriedade ao changeset
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
