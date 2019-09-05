defmodule Perspective.Reactor.State do
  defstruct last_event_processed: nil, data: nil

  def new() do
    %__MODULE__{}
  end

  def from(last_event_processed: last_event_processed, data: data) do
    %__MODULE__{
      last_event_processed: last_event_processed,
      data: data
    }
  end

  def update(old_data, new_data, %{id: id}) do
    old_data
    |> Map.put(:last_event_processed, id)
    |> Map.put(:data, new_data)
  end

  def update(old_data, new_data, _) do
    old_data
    |> Map.put(:last_event_processed, nil)
    |> Map.put(:data, new_data)
  end
end
