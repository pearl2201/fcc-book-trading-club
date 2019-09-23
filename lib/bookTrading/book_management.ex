defmodule BookTrading.BookManagement do
  import Ecto.Query, warn: false
  alias BookTrading.Repo

  alias BookTrading.BookTrade.Book

  def list_user_book(owner_id) do
    query = from b in Book, where: b.owner_id == ^owner_id, select: b
    Repo.all(query)
  end

  def list_tradable_book() do
    query =
      from b in Book,
        where: is_nil(b.transaction_given_id) and is_nil(b.transaction_received_id),
        select: b

    Repo.all(query)
  end

  def list_tradable_book(except_user_id) do
    query =
      from b in Book,
        where:
          b.owner_id != ^except_user_id and is_nil(b.transaction_given_id) and
            is_nil(b.transaction_received_id),
        select: b

    Repo.all(query)
  end

  def list_tradable_book(except_user_id) do
    query =
      from b in Book,
        where:
          b.owner_id != ^except_user_id and is_nil(b.transaction_given_id) and
            is_nil(b.transaction_received_id),
        select: b

    Repo.all(query)
  end

  def add_user_book(attrs \\ %{}, owner_id) do
    %Book{} |> Book.changeset(Map.put(attrs, "owner_id", owner_id)) |> Repo.insert()
  end

  def change_book(%Book{} = book) do
    book |> Book.changeset(%{})
  end

  def get_book!(book_id) do
    Repo.get!(Book, book_id)
  end

  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  def update_book(%Book{} = book, attrs \\ %{}) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end
end
