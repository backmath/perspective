defmodule Perspective.Core.Users do
  use Perspective.Index

  index_key(%{data: %{user_id: user_id}}) do
    user_id
  end

  initial_value do
    %Perspective.Core.User{}
  end

  index(%Perspective.Core.UserAdded{data: data}, user) do
    user
    |> Map.put(:id, data.user_id)
    |> Map.put(:username, data.username)
  end
end
