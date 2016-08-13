defmodule PatternRedirect.LayoutView do
  use PatternRedirect.Web, :view
  import Plug.Conn

  @site_title "PatternRedirect"

  def is_login?(conn) do
    is_number(get_session(conn, :user_id))
  end

  def title(conn) do
    case Map.get(conn.assigns, :title, "") do
      "" -> @site_title
      title -> "#{title} - #{@site_title}" 
    end
  end
end
