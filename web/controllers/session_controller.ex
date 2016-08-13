defmodule PatternRedirect.SessionController do
  use PatternRedirect.Web, :controller
  import Comeonin.Bcrypt
  alias PatternRedirect.User
  
  def new(conn, _) do
    render(conn, "new.html", title: "Log in")
  end

  def create(conn, %{"session" => form}) do
    user = Repo.get_by(User, email: form["email"])
    true = checkpw(form["password"], user.password)

    put_session(conn, :user_id, user.id)
    |> redirect(to: user_path(conn, :show, user.id))
  end

  def delete(conn, _) do
    clear_session(conn)
    |> redirect(to: session_path(conn, :create))
  end
end