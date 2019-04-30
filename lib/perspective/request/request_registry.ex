defmodule Perspective.RequestRegistry do
  use Perspective.Reactor

  defmodule RegisterRequest do
    defstruct [:request]
  end

  initial_state do
    %{}
  end

  update(%RegisterRequest{request: %{id: request_id, actor_id: actor_id}}, state) do
    Map.put(state, request_id, actor_id)
  end

  def register(request) do
    Perspective.RequestRegistry.send(%RegisterRequest{request: request})
  end
end
