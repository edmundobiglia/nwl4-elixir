defmodule Rocketpay.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    # :users é o nome da tabela
    create table :users do

      ## colunas da tabela (:nome, :tipo)
      add :name, :string
      add :age, :integer
      add :email, :string
      add :password_hash, :string
      add :nickname, :string

      # esta fn adiciona automaticamente a coluna insertedAt e updatedAt
      timestamps()
    end

    # funções para garantir que email e nickname são únicos
    create unique_index(:users, [:email])
    create unique_index(:users, [:nickname])
  end
end
