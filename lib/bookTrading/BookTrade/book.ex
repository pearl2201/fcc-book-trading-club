defmodule BookTrading.BookTrade.Book do
  use Ecto.Schema
  import Ecto.Changeset
  use Arc.Ecto.Schema
  @require_attrs [:name, :owner_id]
  @option_attrs [:description, :cover_url, :transaction_given_id, :transaction_received_id]

  schema "books" do
    field :name, :string
    field :description, :string
    field :cover_url, BookTrading.ImageUploader.Type
    belongs_to :owner, BookTrading.Account.User
    belongs_to :transaction_given, BookTrading.BookTrade.Transaction
    belongs_to :transaction_received, BookTrading.BookTrade.Transaction
    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, @require_attrs ++ @option_attrs)
    |> validate_required(@require_attrs)
    |> cast_attachments(attrs, [:cover_url])
  end
end
