defmodule PatternRedirect.UserController do
  use PatternRedirect.Web, :controller
  alias PatternRedirect.User
  alias PatternRedirect.Pattern
  alias PatternRedirect.Pipeline

  plug :fetch_user
  plug :check_session_user, [:edit, :update, :delete]

  def new(conn, _) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    changeset = User.changeset(%User{}, params["user"])

    case Repo.insert(changeset) do
      {:ok, user} ->
        put_session(conn, :user_id, user.id)
        |> redirect(to: user_path(conn, :show, user.id))
      
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(%Plug.Conn{assigns: %{user: user}} = conn, _) do
    render(conn, "show.html", user: user,
                              patterns: fetch_patterns(user.id),
                              pipelines: fetch_pipelines(user.id))
  end

  def edit(%Plug.Conn{assigns: %{user: user}} = conn, _) do
    changeset = User.changeset(user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{user: user}} = conn, params) do
    changeset = User.changeset(user, params["user"])

    case Repo.update(changeset) do
      {:ok, user} ->
        redirect(conn, to: user_path(conn, :show, user.id))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    #
  end

  defp fetch_user(%Plug.Conn{params: %{"id" => id}, assigns: assigns} = conn, _) do
    {int, _} = Integer.parse(id)

    maybe_fetch_user(conn, int, assigns[:session_user])
  end

  defp fetch_user(conn, _), do: conn

  defp maybe_fetch_user(conn, user_id, %{id: id} = session_user) when user_id == id do
    assign(conn, :user, session_user)
  end

  defp maybe_fetch_user(conn, user_id, _) do
    case Repo.get(User, user_id) do
      nil ->
        render(conn, PatternRedirect.ErrorView, "404.html")
        |> halt

      user ->
        assign(conn, :user, user)
    end
  end

  defp fetch_patterns(user_id) do
    query = from p in Pattern,
      where: p.user_id == ^user_id,
      order_by: p.inserted_at

    Repo.all(query)
  end

  defp fetch_pipelines(user_id) do
    query = from p in Pipeline,
      where: p.user_id == ^user_id,
      order_by: p.inserted_at

    Repo.all(query)
  end

  defp check_session_user(%Plug.Conn{assigns: %{user: user}} = conn, actions) do
    cond do
      get_session(conn, :user_id) == user.id -> conn

      Enum.member?(actions, conn.private[:phoenix_action]) ->
        render(conn, PatternRedirect.ErrorView, "404.html")
        |> halt

      true -> conn
    end
  end

  defp check_session_user(conn, _), do: conn
end