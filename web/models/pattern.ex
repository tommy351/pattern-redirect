defmodule PatternRedirect.Pattern do
  use PatternRedirect.Web, :model

  schema "patterns" do
    field :name, :string
    field :rule, :string
    field :target, :string

    belongs_to :user, PatternRedirect.User

    timestamps()
  end

  def changeset(pattern, params \\ %{}) do
    pattern
    |> cast(params, [:name, :rule, :target])
    |> validate_required([:name, :rule, :target])
  end

  def replace(pattern, str) do
    case Regex.compile(pattern.rule) do
      {:ok, regex} ->
        if Regex.match?(regex, str) do
          {:ok, Regex.replace(regex, str, pattern.target)}
        else
          {:error, nil}
        end
    
      {:error, err} -> {:error, err}
    end
  end
end
