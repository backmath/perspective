defmodule Perspective.AuthenticationVault do
  use Perspective.Reactor

  initial_state(_backup) do
    Perspective.EventChain.all()
    |> Stream.filter(fn %event_type{} ->
      event_type == Core.UserAdded
    end)
    |> Enum.reduce(%{}, fn event, accumulator ->
      Map.put(accumulator, event.data.username, {event.data.user_id, event.data.username, event.data.password_hash})
    end)
  end

  update(%Core.UserAdded{data: %{user_id: user_id, username: username, password_hash: password_hash}}, state) do
    Map.put(state, username, {user_id, username, password_hash})
  end

  def credentials_for(username) do
    case get() |> Map.get(username, nil) do
      nil -> {:error, %Perspective.Authentication.UsernameNotFound{username: username}}
      password_hash -> {:ok, password_hash}
    end
  end
end
