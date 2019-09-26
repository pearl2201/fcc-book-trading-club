defmodule BookTradingWeb.BookController do
  use BookTradingWeb, :controller

  alias BookTrading.BookTrade.Book
  alias BookTrading.BookManagement

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    books = BookManagement.list_not_owner_book(current_user.id)

    conn
    |> put_user
    |> render("index.html", books: books)
  end

  def new(conn, _params) do
    changeset = BookManagement.change_book(%Book{})

    conn
    |> put_user
    |> render("new.html", changeset: changeset, book: nil)
  end

  def create(conn, %{"book" => book_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    case BookManagement.add_user_book(book_params, current_user.id) do
      {:ok, book} ->
        conn
        |> put_user
        |> put_flash(:info, "User1 created successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_user
        |> render("new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = BookManagement.get_book!(id)

    case BookManagement.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_user
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_user
        |> render("edit.html", book: book, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    book = BookManagement.get_book!(id)
    changeset = BookManagement.change_book(book)

    conn
    |> put_user
    |> render("edit.html", book: book, changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    book = BookManagement.get_book!(id)

    conn
    |> put_user
    |> render("show.html", book: book)
  end

  def delete(conn, %{"id" => id}) do
    book = BookManagement.get_book!(id)
    {:ok, _book} = BookManagement.delete_book(book)

    conn
    |> put_user
    |> put_flash(:info, "User1 deleted successfully.")
    |> redirect(to: Routes.book_path(conn, :index))
  end
end
