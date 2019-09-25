defmodule BookTradingWeb.TransactionController do
  use BookTradingWeb, :controller

  alias BookTrading.BookManagement
  alias BookTrading.BookTransaction

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_user_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end

  def new(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_user_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end

  def create(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_user_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end

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

  def invite(conn, %{"book_given_id" => book_given_id, "book_received_id" => book_received_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    {:ok, transaction} = BookTransaction.invite(book_given_id, current_user.id, book_received_id)

    conn
    |> put_user
    |> put_flash(:info, "Book updated successfully.")
    |> redirect(to: Routes.transaction_path(conn, :show, transaction))
  end

  def accept(conn, %{"transaction_id" => transaction_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    {:ok, book} = BookTransaction.accept(transaction_id, current_user.id)

    conn
    |> put_user
    |> put_flash(:info, "Book updated successfully.")
    |> redirect(to: Routes.book_path(conn, :show, book))
  end
end
