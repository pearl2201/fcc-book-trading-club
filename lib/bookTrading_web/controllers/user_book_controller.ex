defmodule BookTradingWeb.UserBookController do
  use BookTradingWeb, :controller

  alias BookTrading.BookTrade.Book
  alias BookTrading.BookManagement

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_user_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end

  def new(conn, _params) do
    changeset = BookManagement.change_book(%Book{})

    conn
    |> put_user
    |> render("new.html", changeset: changeset, token: get_csrf_token())
  end

  def create(conn, params) do
    IO.inspect(params)
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
