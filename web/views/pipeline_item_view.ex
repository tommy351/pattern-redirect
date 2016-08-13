defmodule PatternRedirect.PipelineItemView do
  use PatternRedirect.Web, :view

  def pattern_options(patterns) do
    Enum.map(patterns, fn pattern -> 
      {pattern.name, pattern.id}
    end)
  end
end