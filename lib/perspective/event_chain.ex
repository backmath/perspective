defmodule Perspective.EventChain do
  use Agent

  def apply_event(event) do
    Agent.update(__MODULE__, fn events -> [event | events] end)
  end

  def last() do
    Agent.get(__MODULE__, fn [latest | _rest] -> latest end)
  end

  def since(id) do
    Agent.get(__MODULE__, fn events ->
      Enum.reduce_while(events, [], fn event, since ->
        if event.id == id, do: {:halt, since}, else: {:cont, [event | since]}
      end)
    end)
  end

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end
end
