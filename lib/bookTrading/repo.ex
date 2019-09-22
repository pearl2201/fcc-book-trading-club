defmodule BookTrading.Repo do
  use Ecto.Repo,
    otp_app: :bookTrading,
    adapter: Ecto.Adapters.Postgres
end
