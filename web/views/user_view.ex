defmodule PatternRedirect.UserView do
  use PatternRedirect.Web, :view
  import Plug.Conn

  def is_current_user?(conn, user) do
    get_session(conn, :user_id) == user.id
  end
end