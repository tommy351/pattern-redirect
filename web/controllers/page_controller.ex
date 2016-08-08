defmodule PatternRedirect.PageController do
  use PatternRedirect.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
