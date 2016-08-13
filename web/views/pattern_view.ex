defmodule PatternRedirect.PatternView do
  use PatternRedirect.Web, :view
  import Plug.Conn

  def is_author?(conn, pattern) do
    get_session(conn, :user_id) == pattern.user_id
  end
end
