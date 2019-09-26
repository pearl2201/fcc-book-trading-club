defmodule BookTrading.BookTrade.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :finished, :boolean, default: false
    has_one :book_given, BookTrading.BookTrade.Book, foreign_key: :transaction_given_id, on_delete: :nilify_all
    has_one :book_received, BookTrading.BookTrade.Book, foreign_key: :transaction_received_id, on_delete: :nilify_all

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    IO.inspect(attrs)

    transaction
    |> cast(attrs, [:finished])
  end
end
