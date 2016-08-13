defmodule PatternRedirect.PipelineView do
  use PatternRedirect.Web, :view
  import Plug.Conn

  def is_author?(conn, pipeline) do
    get_session(conn, :user_id) == pipeline.user_id
  end
end