defmodule BookTradingWeb.TransactionController do
  use BookTradingWeb, :controller

  alias BookTrading.BookManagement
  alias BookTrading.BookTransaction
  alias BookTrading.Account

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    to_me_transactions = BookTransaction.list_transaction(:to_me, :not_finished, current_user.id)

    from_me_transactions =
      BookTransaction.list_transaction(:from_me, :not_finished, current_user.id)

    IO.inspect(to_me_transactions)
    IO.inspect(from_me_transactions)

    conn
    |> put_user
    |> render("index.html",
      to_me_transactions: to_me_transactions,
      from_me_transactions: from_me_transactions,
      token: get_csrf_token()
    )
  end

  def new(conn, %{"id" => book_request_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    book_request = BookManagement.get_book!(book_request_id)
    book_owner = Account.get_user!(book_request.owner_id)
    books = BookManagement.list_tradable_book(current_user.id)

    conn
    |> put_user
    |> render("new.html",
      books: books,
      book_request: book_request,
      book_owner: book_owner,
      token: get_csrf_token()
    )
  end

  def create(conn, %{"book_given_id" => book_given_id, "book_received_id" => book_received_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    {:ok, _} = BookTransaction.invite(book_given_id, current_user.id, book_received_id)

    conn
    |> put_user
    |> put_flash(:info, "Book updated successfully.")
    |> redirect(to: Routes.transaction_path(conn, :index))
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    transaction = BookTransaction.get_transaction!(id)

    conn
    |> put_user
    |> render("show.html", transaction: transaction)
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    {:ok, _transaction} = BookTransaction.delete(id, current_user.id)

    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: Routes.book_path(conn, :index))
  end

  def accept(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    {:ok, book} = BookTransaction.accept(id, current_user.id)

    conn
    |> put_user
    |> put_flash(:info, "Transaction successfully.")
    |> redirect(to: Routes.book_path(conn, :show, book))
  end

  def decline(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    {:ok, _} = BookTransaction.decline(id, current_user.id)

    conn
    |> put_user
    |> put_flash(:info, "Decline transaction successfully.")
    |> redirect(to: Routes.transaction_path(conn, :index))
  end
end
