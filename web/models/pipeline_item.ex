defmodule PatternRedirect.PipelineItem do
  use PatternRedirect.Web, :model

  schema "pipeline_items" do
    belongs_to :pipeline, PatternRedirect.Pipeline
    belongs_to :pattern, PatternRedirect.Pattern

    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
    |> cast(params, [:pipeline_id, :pattern_id])
  end
end