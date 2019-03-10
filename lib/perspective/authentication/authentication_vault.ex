defmodule Perspective.AuthenticationVault do
  use Perspective.Reactor

  initial_state do
    %{}
  end

  update(%Perspective.DomainEvent{event_type: "Core.UserAdded"} = event, state) do
    Map.put(state, event.event.username, event.event.password_hash)
  end

  def password_hash_for(username) do
    case get() |> Map.get(username, nil) do
      nil -> {:error, :username_not_found}
      password_hash -> {:ok, password_hash}
    end
  end
end
