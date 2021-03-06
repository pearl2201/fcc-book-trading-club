defmodule BookTradingWeb.OAuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use BookTradingWeb, :controller
  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias BookTrading.OAuthAccount
  alias BookTrading.Account
  alias BookTrading.Account.Guardian, as: Account_Guardian

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    IO.inspect("delete")

    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def logout(conn, _) do
    IO.inspect("logout")

    conn
    |> Guardian.Plug.sign_out(Account_Guardian, _opts = [])
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case OAuthAccount.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(Account_Guardian, user)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def hack(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    conn
    |> Guardian.Plug.sign_in(Account_Guardian, user)
    |> redirect(to: "/")
  end
end
