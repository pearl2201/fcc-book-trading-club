defmodule BookTrading.Account.Plug do
  import Plug.Conn
  import Guardian.Plug
  def init(opts), do: opts

  def call(conn, _opts) do


    conn
  end
end
