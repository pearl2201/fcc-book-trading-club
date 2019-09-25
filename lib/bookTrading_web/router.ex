defmodule BookTradingWeb.Router do
  use BookTradingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BookTrading.Account.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BookTrading.Account.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", BookTradingWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/signup", PasswordAuthController, :new
    post "/signup", PasswordAuthController, :create
    get "/signin", PasswordAuthController, :get_signin
    post "/signin", PasswordAuthController, :signin
    get "/signout", AuthController, :signout
    resources "/books", BookController, only: [:show]
  end

  scope "/", BookTradingWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    resources "/books", BookController
    resources "/transactions", TransactionController

    scope "/users" do
    end

    post "/books/:id_book/invite", TransactionController, :invite
    post "/books/:id_book/accept", TransactionController, :accept
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookTradingWeb do
  #   pipe_through :api
  # end
end
