defmodule BullishWeb.Router do
  use BullishWeb, :router
  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(BullishWeb.Plugs.SetCurrentUser, repo: Bullish.Repo)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", BullishWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", BullishWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    get "/logout", AuthController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", BullishWeb do
  #   pipe_through :api
  # end
end
