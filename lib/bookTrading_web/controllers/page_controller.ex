defmodule BookTradingWeb.PageController do
  use BookTradingWeb, :controller

  def index(conn, _params) do


    #render(conn, "index.html", current_user: current_user)
    conn
    |> put_user
    |> render("index.html")
  end
end
