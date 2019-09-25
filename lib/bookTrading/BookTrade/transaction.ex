defmodule BookTrading.BookTrade.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :finished, :boolean, default: false
    has_one :book_given, BookTrading.BookTrade.Book, foreign_key: :transaction_given_id
    has_one :book_received, BookTrading.BookTrade.Book, foreign_key: :transaction_received_id

    belongs_to :requester, BookTrading.Account.User
    belongs_to :receiver, BookTrading.Account.User

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:book_given_id, :book_received_id, :requester_id, :accepter_id])
  end

end
