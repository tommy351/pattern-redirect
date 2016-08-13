defmodule PatternRedirect.Pipeline do
  use PatternRedirect.Web, :model

  schema "pipelines" do
    field :name, :string

    belongs_to :user, PatternRedirect.User

    timestamps()
  end

  def changeset(pipeline, params \\ %{}) do
    pipeline
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end