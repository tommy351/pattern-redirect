defmodule PatternRedirect.SessionController do
  use PatternRedirect.Web, :controller
  import Comeonin.Bcrypt
  alias PatternRedirect.User
  
  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => form}) do
    case Repo.get_by(User, email: form["email"]) do
      nil ->
        render(conn, "new.html")

      user ->
        if checkpw(form["password"], user.password) do
          put_session(conn, :user_id, user.id)
          |> redirect(to: user_path(conn, :show, user.id))
        else
          render(conn, "new.html")
        end
    end
  end

  def delete(conn, _params) do
    clear_session(conn)
    |> redirect(to: session_path(conn, :create))
  end
end