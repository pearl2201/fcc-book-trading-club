defmodule BookTradingWeb.PageController do
  use BookTradingWeb, :controller

  alias BookTrading.BookManagement

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    books =
      if current_user != nil do
        BookManagement.list_not_owner_book(current_user.id)
      else
        BookManagement.list_books()
      end

    conn
    |> put_user
    |> render("index.html", books: books)
  end
end
