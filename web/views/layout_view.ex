defmodule PatternRedirect.LayoutView do
  use PatternRedirect.Web, :view
  import Plug.Conn

  def is_login?(conn) do
    is_number(get_session(conn, :user_id))
  end
end
