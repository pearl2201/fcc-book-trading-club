defmodule BookTradingWeb.AuthController do
  use BookTradingWeb, :controller
  alias BookTrading.Account.Guardian, as: Account_Guardian

  def signout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out(Account_Guardian, _opts = [])
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
