defmodule PatternRedirect.Router do
  use PatternRedirect.Web, :router
  alias PatternRedirect.Repo
  alias PatternRedirect.User

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_session_user
  end

  scope "/", PatternRedirect do
    pipe_through :browser

    get "/", PageController, :index

    get "/signup", UserController, :new
    post "/signup", UserController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete

    resources "/users", UserController, only: [:show, :edit, :update, :delete]
    resources "/patterns", PatternController, except: [:index]
    resources "/pipelines", PipelineController, except: [:index]
    resources "/pipeline_items", PipelineItemController, only: [:update, :delete]
    resources "/pipelines/:pipeline_id/items", PipelineItemController, only: [:new, :create]
  end

  defp fetch_session_user(conn, _) do
    case get_session(conn, :user_id) do
      id when is_number(id) ->
        assign(conn, :session_user, Repo.get(User, id))
      
      _ -> conn
    end
  end
end
