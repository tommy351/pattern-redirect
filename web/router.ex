defmodule PatternRedirect.Router do
  use PatternRedirect.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PatternRedirect do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/signup", UserController, :new
    post "/signup", UserController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    resources "/users", UserController, only: [:show, :update, :delete]
    resources "/patterns", PatternController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PatternRedirect do
  #   pipe_through :api
  # end
end
