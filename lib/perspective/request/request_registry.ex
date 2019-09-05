defmodule Perspective.RequestRegistry do
  use Perspective.GenServer

  initial_state do
    %{}
  end

  def register(%{id: request_id, actor_id: actor_id} = request) do
    cast({:register, %{request_id: request_id, actor_id: actor_id}})
    request
  end

  def complete(%{id: request_id} = _event) do
    cast({:complete, request_id})
  end

  def handle_cast({:register, %{request_id: request_id, actor_id: actor_id}}, state) do
    new_state = Map.put(state, request_id, actor_id)
    {:noreply, new_state}
  end

  def handle_cast({:complete, %{id: event_id}}, state) do
    # Transform event_id/request_id
    new_state = Map.delete(state, event_id)
    # Do something to notify actor
    {:noreply, new_state}
  end
end
