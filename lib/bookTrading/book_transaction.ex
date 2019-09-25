defmodule BookTrading.BookTransaction do
  import Ecto.Query, warn: false
  alias BookTrading.Repo

  alias BookTrading.Account.User
  alias BookTrading.BookTrade.Book
  alias BookTrading.BookTrade.Transaction
  alias BookTrading.BookManagement

  @doc """
    make request to tradebook
  """
  def invite(book_given_id, current_user_id, book_received_id) do
    # Query book of requester
    query =
      from b in Book,
        where:
          b.id == ^book_given_id and is_nil(b.transaction_given_id) and
            is_nil(b.transaction_received_id) and b.owner_id == ^current_user_id,
        select: b

    book_given = Repo.one(query)

    # Query book of receiver
    query =
      from b in Book,
        where:
          b.id == ^book_received_id and is_nil(b.transaction_given_id) and
            is_nil(b.transaction_received_id),
        select: b

    book_received = Repo.one(query)

    if book_given != nil and book_received != nil do
      # make transaction
      {:ok, transaction} =
        %Transaction{}
        |> Transaction.changeset(%{
          "requester_id" => current_user_id,
          "receiver_id" => book_received.id
        })
        |> Repo.insert()

      BookManagement.set_transaction_to_book(:book_given, book_given, transaction)
      BookManagement.set_transaction_to_book(:book_received, book_received, transaction)

      {:ok, transaction}
    else
      {:error, :transaction_is_not_valid}
    end
  end

  @doc """
    Accept book transaction

  """
  def accept(transaction_id, current_user_id) do
    # query transaction
    transaction =
      Repo.get_by(Transaction, id: transaction_id, receiver_id: current_user_id, finished: false)
      |> Repo.preload([:book_given, :book_received])

    if transaction do
      # complete transaction
      transaction
      |> Transaction.changeset(%{
        finished: true
      })
      |> Repo.update()

      # give book from requester to inviter
      transaction.book_received
      |> Book.changeset(%{owner_id: transaction.requester_id})
      |> Repo.update()

      # give book from inviter to requester
      transaction.book_given
      |> Book.changeset(%{owner_id: transaction.receiver_id})
      |> Repo.update()

      {:ok, transaction.book}
    else
      {:error, :transaction_is_not_valid}
    end
  end

  def decline(transaction_id, current_user_id) do
    Repo.get_by(Transaction, id: transaction_id, receiver_id: current_user_id, finished: false)
    |> Repo.delete()
  end

  def delete(transaction_id, current_user_id) do
    Repo.get_by(Transaction, id: transaction_id, requester_id: current_user_id, finished: false)
    |> Repo.delete()
  end

  @doc """
  Returns the list of transaction finished from user.

  ## Examples

      iex> list_transaction(:from_me, :finished, 1)
      [{"transaction" => %Transaction{},"requester" => %User{}, "receiver" => %User{} }, ...]

  """
  def list_transaction(:from_me, :finished, current_user_id) do
    query =
      from t in Transaction,
        where: t.requester_id == ^current_user_id and t.finished == true,
        select: t

    Repo.all(query)
    |> Enum.map(fn x -> compose_transaction(x) end)
  end

  @doc """
  Returns the list of transaction finished to user.

  ## Examples
      iex> list_transaction(:to_me, :finished, 1)
       [{"transaction" => %Transaction{},"requester" => %User{}, "receiver" => %User{} }, ...]
  """
  def list_transaction(:to_me, :finished, current_user_id) do
    query =
      from t in Transaction,
        where: t.receiver_id == ^current_user_id and t.finished == true,
        select: t

    Repo.all(query)
    |> Enum.map(fn x -> compose_transaction(x) end)
  end

  @doc """
  Returns the list of transaction not finished to user.

  ## Examples
      iex> list_transaction(:to_me, :not_finished, 1)
       [{"transaction" => %Transaction{},"requester" => %User{}, "receiver" => %User{} }, ...]
  """
  def list_transaction(:to_me, :not_finished, current_user_id) do
    query =
      from t in Transaction,
        where: t.receiver_id == ^current_user_id and t.finished == false,
        select: t

    Repo.all(query)
    |> Enum.map(fn x -> compose_transaction(x) end)
  end

  @doc """
  Returns the list of transaction not finished from user.

  ## Examples
      iex> list_transaction(:to_me, :not_finished, 1)
       [{"transaction" => %Transaction{},"requester" => %User{}, "receiver" => %User{} }, ...]
  """
  def list_transaction(:from_me, :not_finished, current_user_id) do
    query =
      from t in Transaction,
        where: t.requester_id == ^current_user_id and t.finished == false,
        select: t

    Repo.all(query)
    |> Enum.map(fn x -> compose_transaction(x) end)
  end

  @doc """
  compose return transaction

  ## Examples
      iex> compose_transaction(transaction)
       [{"transaction" => %Transaction{},"requester" => %User{}, "receiver" => %User{} }, ...]
  """
  def compose_transaction(%Transaction{} = transaction) do
    query =
      from u in User,
        where: u.id == ^transaction.receiver_id,
        select: %{"username" => u.username, "id" => u.id}

    receiver = Repo.one(query)

    query =
      from u in User,
        where: u.id == ^transaction.requester_id,
        select: %{"username" => u.username, "id" => u.id}

    requester = Repo.one(query)
    %{"transaction" => transaction, "requester" => requester, "receiver" => receiver}
  end

  def get_transaction!(id) do
    Repo.get!(Transaction, id)
  end
end
