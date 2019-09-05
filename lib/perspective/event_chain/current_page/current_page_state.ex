defmodule Perspective.EventChain.CurrentPage.State do
  use Perspective.Config
  alias __MODULE__

  defstruct [:events]

  def new, do: %State{events: []}

  def add(%{events: events}, new_events) when is_list(new_events), do: %State{events: events ++ new_events}
  def add(state, new_event), do: add(state, [new_event])

  def event_count_remaining(state) do
    count = config(:max_events_per_page) - length(state.events)

    if count > 0 do
      count
    else
      0
    end
  end

  def is_full?(state), do: length(state.events) >= config(:max_events_per_page)
end
