defmodule BookTrading.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :avatar_url, :string
    has_many :oauth_member, BookTrading.Account.OAuthMember
    has_one :password_member, BookTrading.Account.PasswordMember
    has_many :transaction_given, BookTrading.BookTrade.Transaction, foreign_key: :requester_id
    has_many :transaction_received, BookTrading.BookTrade.Transaction, foreign_key: :receiver_id
    has_many :books, BookTrading.BookTrade.Book, foreign_key: :owner_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :avatar_url])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
