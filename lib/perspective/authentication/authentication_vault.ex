defmodule Perspective.AuthenticationVault do
  use Perspective.Reactor

  initial_state do
    %{}
  end

  update(%Core.UserAdded{data: data}, state) do
    Map.put(state, data.username, data)
  end

  def credentials_for(username) do
    case data() |> Map.get(username, nil) do
      nil -> {:error, %Perspective.Authentication.UsernameNotFound{username: username}}
      password_hash -> {:ok, password_hash}
    end
  end
end
