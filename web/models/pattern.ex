defmodule PatternRedirect.Pattern do
  use PatternRedirect.Web, :model

  schema "patterns" do
    field :rule, :string
    field :target, :string

    belongs_to :user, PatternRedirect.User

    timestamps()
  end

  def changeset(pattern, params \\ %{}) do
    pattern
    |> cast(params, [:rule, :target])
    |> validate_required([:rule, :target])
  end
end
