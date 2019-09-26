defmodule BookTradingWeb.UserController do
  use BookTradingWeb, :controller

  alias BookTrading.BookManagement
  alias BookTrading.Account

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_user_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end

  def show(conn, %{"id" => id}) do
    books = BookManagement.list_user_book(id)
    user = Account.get_user!(id)

    conn
    |> put_user
    |> render("show.html", books: books, user: user)
  end
end
