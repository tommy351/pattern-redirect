defmodule PatternRedirect.PatternController do
  use PatternRedirect.Web, :controller
  alias PatternRedirect.Pattern

  plug :fetch_pattern
  plug :check_author, [:edit, :update, :delete]

  def new(conn, _) do
    changeset = Pattern.changeset(%Pattern{})
    render(conn, "new.html", changeset: changeset, title: "New pattern")
  end

  def create(conn, params) do
    pattern = %Pattern{user_id: get_session(conn, :user_id)}
    changeset = Pattern.changeset(pattern, params["pattern"])
    {:ok, pattern} = Repo.insert(changeset)

    redirect(conn, to: pattern_path(conn, :show, pattern.id))
  end

  def show(%Plug.Conn{assigns: %{pattern: pattern}, query_params: %{"go" => go}} = conn, _) when go != "" do
    case Pattern.replace(pattern, go) do
      {:ok, url} ->
        redirect(conn, external: url)

      {:error, err} ->
        redirect(conn, to: pattern_path(conn, :show, pattern.id))
    end
  end

  def show(%Plug.Conn{assigns: %{pattern: pattern}} = conn, _) do
    render(conn, "show.html", pattern: pattern, title: pattern.name)
  end

  def edit(%Plug.Conn{assigns: %{pattern: pattern}} = conn, params) do
    changeset = Pattern.changeset(pattern)
    render(conn, "edit.html", changeset: changeset, title: "Edit pattern")
  end

  def update(%Plug.Conn{assigns: %{pattern: pattern}} = conn, params) do
    changeset = Pattern.changeset(pattern, params["pattern"])
    {:ok, pattern} = Repo.update(changeset)

    redirect(conn, to: pattern_path(conn, :show, pattern.id))
  end

  def delete(%Plug.Conn{assigns: %{pattern: pattern}} = conn, params) do
    {:ok, _} = Repo.delete(pattern)
    redirect(conn, to: user_path(conn, :show, get_session(conn, :user_id)))
  end

  defp fetch_pattern(%Plug.Conn{params: %{"id" => id}} = conn, _) do
    case Repo.get(Pattern, id) do
      nil ->
        render(conn, PatternRedirect.ErrorView, "404.html")
        |> halt

      pattern ->
        assign(conn, :pattern, pattern)
    end
  end

  defp fetch_pattern(conn, _), do: conn

  defp check_author(%Plug.Conn{assigns: %{pattern: pattern}} = conn, actions) do
    cond do
      get_session(conn, :user_id) == pattern.user_id -> conn

      Enum.member?(actions, conn.private[:phoenix_action]) ->
        render(conn, PatternRedirect.ErrorView, "404.html")
        |> halt

      true -> conn
    end
  end

  defp check_author(conn, _), do: conn
end
