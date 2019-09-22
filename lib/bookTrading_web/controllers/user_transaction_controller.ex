defmodule BookTradingWeb.UserTransactionController do
  use BookTradingWeb, :controller

  alias BookTrading.BookManagement

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

  def update(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_user_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end

  def edit(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_user_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end

  def show(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_user_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end

  def delete(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_user_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end
end
