defmodule PatternRedirect.PipelineController do
  use PatternRedirect.Web, :controller
  import Ecto.Changeset
  alias PatternRedirect.Pipeline
  alias PatternRedirect.PipelineItem
  alias PatternRedirect.Pattern

  plug :fetch_pipeline
  plug :check_author, [:edit, :update, :delete]

  def new(conn, _) do
    changeset = Pipeline.changeset(%Pipeline{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    changeset = Pipeline.changeset(%Pipeline{}, params["pipeline"])
    |> put_change(:user_id, get_session(conn, :user_id))

    case Repo.insert(changeset) do
      {:ok, pipeline} ->
        redirect(conn, to: pipeline_path(conn, :show, pipeline.id))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%Plug.Conn{assigns: %{pipeline: pipeline}, query_params: %{"go" => go}} = conn, _) when go != "" do
    result = case fetch_pipeline_items(pipeline.id) do
      items when length(items) > 0 ->
        Enum.reduce(items, nil, fn item, acc ->
          case acc do
            {:ok, url} -> acc
            _ -> Pattern.replace(item.pattern, go)
          end
        end)

      _ -> {:error, nil}
    end

    case result do
      {:ok, url} ->
        redirect(conn, external: url)

      {:error, err} ->
        redirect(conn, to: pipeline_path(conn, :show, pipeline.id))
    end
  end

  def show(%Plug.Conn{assigns: %{pipeline: pipeline}} = conn, _) do
    render(conn, "show.html", pipeline: pipeline,
                              pipeline_items: fetch_pipeline_items(pipeline.id))
  end

  def edit(%Plug.Conn{assigns: %{pipeline: pipeline}} = conn, _) do
    changeset = Pipeline.changeset(pipeline)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{pipeline: pipeline}} = conn, params) do
    changeset = Pipeline.changeset(pipeline, params["pipeline"])

    case Repo.update(changeset) do
      {:ok, pipeline} ->
        redirect(conn, to: pipeline_path(conn, :show, pipeline.id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset) 
    end
  end

  def delete(%Plug.Conn{assigns: %{pipeline: pipeline}} = conn, _) do
    case Repo.delete(pipeline) do
      {:ok, _} ->
        redirect(conn, to: user_path(conn, :show, get_session(conn, :user_id)))

      {:error, _} ->
        render(conn, "show.html", pipeline: pipeline)
    end
  end

  defp fetch_pipeline(%Plug.Conn{params: %{"id" => id}} = conn, _) do
    case Repo.get(Pipeline, id) do
      nil ->
        render(conn, PatternRedirect.ErrorView, "404.html")
        |> halt

      pipeline ->
        assign(conn, :pipeline, pipeline)
    end
  end

  defp fetch_pipeline(conn, _), do: conn

  defp check_author(%Plug.Conn{assigns: %{pipeline: pipeline}} = conn, actions) do
    cond do
      get_session(conn, :user_id) == pipeline.user_id -> conn

      Enum.member?(actions, conn.private[:phoenix_action]) ->
        render(conn, PatternRedirect.ErrorView, "404.html")
        |> halt

      true -> conn
    end
  end

  defp check_author(conn, _), do: conn

  defp fetch_pipeline_items(pipeline_id) do
    query = from i in PipelineItem,
      where: i.pipeline_id == ^pipeline_id,
      order_by: i.index,
      join: p in assoc(i, :pattern),
      preload: [pattern: p]

    Repo.all(query)
  end
end