defmodule Perspective.AuthenticationVault do
  use Perspective.Reactor

  initial_state(_backup) do
    Perspective.EventChain.since("event:000000000")
    |> Enum.filter(fn event ->
      nil
      # event.event_type == Core.UserAdded
    end)
    |> Enum.reduce(%{}, fn %Perspective.DomainEvent{event: event}, accumulator ->
      Map.put(accumulator, event.username, {event.user_id, event.username, event.password_hash})
    end)
  end

  update(
    %Perspective.DomainEvent{
      event: %Core.UserAdded{user_id: user_id, username: username, password_hash: password_hash}
    },
    state
  ) do
    Map.put(state, username, {user_id, username, password_hash})
  end

  def credentials_for(username) do
    case get() |> Map.get(username, nil) do
      nil -> {:error, %Perspective.Authentication.UsernameNotFound{username: username}}
      password_hash -> {:ok, password_hash}
    end
  end
end
