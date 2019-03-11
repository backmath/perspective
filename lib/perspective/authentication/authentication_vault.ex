defmodule Perspective.AuthenticationVault do
  use Perspective.Reactor

  initial_state(backup) do
    case backup do
      %{last_event_processed: last_event_processed} -> last_event_processed
      _ -> "event:000000000"
    end
    |> Perspective.EventChain.since()
    |> Enum.filter(fn event ->
      event.event_type == Core.UserAdded
    end)
    |> Enum.reduce(%{}, fn event, accumulator ->
      Map.put(accumulator, event.event.username, event.event.password_hash)
    end)
  end

  backup(event, _state) do
    %{last_event_processed: event.event_id}
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
