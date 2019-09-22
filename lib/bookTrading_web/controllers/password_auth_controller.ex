defmodule BookTradingWeb.PasswordAuthController do
  use BookTradingWeb, :controller
  alias BookTrading.PasswordAccount
  alias BookTrading.Account.Guardian, as: Account_Guardian

  def new(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    render(conn, "signup.html", current_user: current_user, token: get_csrf_token())
  end

  def create(conn, params) do
    user = PasswordAccount.create(params)

    conn
    |> Guardian.Plug.sign_in(Account_Guardian, user)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def signin(conn, %{"username" => username, "password" => password}) do
    {:ok, user} = PasswordAccount.authenticate_user(username, password)

    conn
    |> Guardian.Plug.sign_in(Account_Guardian, user)
    |> assign(:current_user, user)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def get_signin(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render(conn, "signin.html", current_user: current_user, token: get_csrf_token())
  end
end
