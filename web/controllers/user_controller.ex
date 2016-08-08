defmodule PatternRedirect.UserController do
  use PatternRedirect.Web, :controller
  alias PatternRedirect.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    changeset = User.changeset(%User{}, params["user"])

    case Repo.insert(changeset) do
      {:ok, user} ->
        put_session(conn, :user_id, user.id)
        |> redirect(to: user_path(conn, :show, user.id))
      
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, params) do
    case Repo.get(User, params["id"]) do
      nil ->
        render(conn, PatternRedirect.ErrorView, "404.html")

      user ->
        render(conn, "show.html", user: user)
    end
  end

  def update(conn, _params) do
    #
  end

  def delete(conn, _params) do
    #
  end
end