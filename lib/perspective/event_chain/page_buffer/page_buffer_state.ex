defmodule Perspective.EventChain.PageBuffer.State do
  defstruct [:events]
  alias __MODULE__

  def new(), do: %State{events: []}
  def add(%State{events: events}, event), do: %State{events: events ++ [event]}

  def has_events?(%State{events: []}), do: false
  def has_events?(%State{events: _events}), do: true

  def take_out(%State{events: events}, amount) do
    {taken, left} = Enum.split(events, amount)
    {%State{events: left}, taken}
  end
end
