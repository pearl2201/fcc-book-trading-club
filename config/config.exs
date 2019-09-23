# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bookTrading,
  ecto_repos: [BookTrading.Repo]

# Configures the endpoint
config :bookTrading, BookTradingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ads0eTCE2cpOOFZDsqUnYFaVyAfdDKMDab9sFpik4eT/p+QKW7RLXUNO50w/nnvM",
  render_errors: [view: BookTradingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BookTrading.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    facebook: { Ueberauth.Strategy.Facebook, [] }
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_CLIENTID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET"),
  redirect_uri: "http://localhost:4000/auth/facebook/callback"

config :bookTrading, BookTrading.Account.Guardian,
  issuer: "bookTrading",
  secret_key: "Nwf//bjBd8wwkhlcNag286LUyTVNv3khmGWWUbGEIp6vKP6v/DS40S+4hY1YzlHZ" # put the result of the mix command above here

config :arc,
  storage_dir: "upload"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
