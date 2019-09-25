defmodule BookTrading.Repo.Migrations.Setup do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :avatar_url, :string

      timestamps()
    end

    create table(:oauth_member) do
      add :provider, :string, null: false
      add :provider_user_id, :string, null: false

      add :user_id, references(:users)
      timestamps()
    end

    create table(:password_member) do
      add :hashed_password, :string, null: false
      add :user_id, references(:users)

      timestamps()
    end

    create table(:books) do
      add :name, :string, null: false
      add :description, :string, null: false
      add :cover_url, :string
      add :owner_id, references(:users)

      timestamps()
    end

    create table(:transactions) do
      add :requester_id, references(:users)
      add :receiver_id, references(:users)
      add :finished, :boolean, default: :false
      timestamps()
    end



    create unique_index(:users, [:email,:username])

    alter table(:books) do
      add :transaction_given_id, references(:transactions)
      add :transaction_received_id, references(:transactions)
    end
  end
end
