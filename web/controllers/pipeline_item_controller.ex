defmodule PatternRedirect.PipelineItemController do
  use PatternRedirect.Web, :controller
  alias PatternRedirect.PipelineItem
  alias PatternRedirect.Pattern
  alias PatternRedirect.Pipeline

  plug :fetch_pipeline
  plug :fetch_pipeline_item

  def new(%Plug.Conn{assigns: %{pipeline: pipeline}} = conn, _) do
    changeset = PipelineItem.changeset(%PipelineItem{pipeline_id: pipeline.id})

    render(conn, "new.html", changeset: changeset,
                             title: "Add to pipeline",
                             patterns: fetch_available_patterns(conn))
  end

  def create(%Plug.Conn{assigns: %{pipeline: pipeline}} = conn, params) do
    changeset = PipelineItem.changeset(%PipelineItem{pipeline_id: pipeline.id}, params["pipeline_item"])
    {:ok, item} = Repo.insert(changeset)

    redirect(conn, to: pipeline_path(conn, :show, item.pipeline_id))
  end

  def update(conn, params) do
  end

  def delete(%Plug.Conn{assigns: %{pipeline_item: item}} = conn, _) do
    {:ok, _} = Repo.delete(item)
    redirect(conn, to: pipeline_path(conn, :show, item.pipeline_id))
  end

  defp fetch_available_patterns(%Plug.Conn{assigns: %{pipeline: pipeline}} = conn) do
    user_id = get_session(conn, :user_id)
    query = from p in Pattern,
      where: p.user_id == ^user_id and not (p.id in fragment(
        "SELECT pattern_id FROM pipeline_items WHERE pipeline_id = ?", ^pipeline.id
      )),
      order_by: p.inserted_at

    Repo.all(query)
  end

  defp fetch_pipeline(%Plug.Conn{params: %{"pipeline_id" => id}} = conn, _) do
    case Repo.get(Pipeline, id) do
      nil ->
        render(conn, PatternRedirect.ErrorView, "404.html")
        |> halt

      pipeline ->
        assign(conn, :pipeline, pipeline)
    end
  end

  defp fetch_pipeline(conn, _), do: conn

  defp fetch_pipeline_item(%Plug.Conn{params: %{"id" => id}} = conn, _) do
    case Repo.get(PipelineItem, id) do
      nil ->
        render(conn, PatternRedirect.ErrorView, "404.html")
        |> halt

      item ->
        assign(conn, :pipeline_item, item)
    end 
  end

  defp fetch_pipeline_item(conn, _), do: conn
end