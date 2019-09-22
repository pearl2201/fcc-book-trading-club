defmodule BookTrading.BookManagement do
  import Ecto.Query, warn: false
  alias BookTrading.Repo

  alias BookTrading.BookTrade.Book

  def list_user_book(owner_id) do
    query = from b in Book, where: b.owner_id == ^owner_id, select: b
    Repo.all(query)
  end

  def add_user_book(attrs \\ %{}, owner_id) do
    %Book{} |> Book.changeset(Map.put(attrs, :owner_id, owner_id)) |> Repo.insert
    
  end
end
