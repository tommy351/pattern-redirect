defmodule PatternRedirect.PatternController do
  use PatternRedirect.Web, :controller
  import Ecto.Changeset
  alias PatternRedirect.Pattern

  plug :fetch_pattern

  def index(conn, _params) do
    #
  end

  def new(conn, _params) do
    changeset = Pattern.changeset(%Pattern{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    changeset = Pattern.changeset(%Pattern{}, params["pattern"])
    |> put_change(:user_id, get_session(conn, :user_id))

    case Repo.insert(changeset) do
      {:ok, pattern} ->
        redirect(conn, to: pattern_path(conn, :show, pattern.id))
      
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%Plug.Conn{assigns: %{pattern: pattern}} = conn, _params) do
    render(conn, "show.html", pattern: pattern)
  end

  def edit(%Plug.Conn{assigns: %{pattern: pattern}} = conn, params) do
    changeset = Pattern.changeset(pattern)
    render(conn, "edit.html", changeset: changeset, params: params)
  end

  def update(%Plug.Conn{assigns: %{pattern: pattern}} = conn, params) do
    changeset = Pattern.changeset(pattern, params["pattern"])

    case Repo.update(changeset) do
      {:ok, pattern} ->
        render(conn, "show.html", pattern: pattern)
        
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, params: params)
    end
  end

  def delete(%Plug.Conn{assigns: %{pattern: pattern}} = conn, params) do
    case Repo.delete(pattern) do
      {:ok, _} ->
        redirect(conn, to: user_path(conn, :show, get_session(conn, :user_id)))

      {:error, _} ->
        render(conn, "show.html", pattern: pattern)
    end
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
end
