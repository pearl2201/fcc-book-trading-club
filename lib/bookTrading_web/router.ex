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

  end

  scope "/", BookTradingWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    post "/transactions/:id/accept", TransactionController, :accept
    post "/transactions/:id/decline", TransactionController, :decline

    resources "/books", BookController, except: [:index, :show]
    resources "/transactions", TransactionController

    resources "/users", UserController, only: [:index, :show]


  end

  scope "/", BookTradingWeb do
    pipe_through [:browser, :auth]
    resources "/books", BookController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookTradingWeb do
  #   pipe_through :api
  # end
end
