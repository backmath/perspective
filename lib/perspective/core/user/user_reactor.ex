defmodule Perspective.Core.User.Reactor do
  use Perspective.Reactor

  update(%Perspective.Core.UserAdded{data: data}, _state) do
    %Perspective.Core.User{}
    |> Map.put(:id, data.user_id)
    |> Map.put(:username, data.username)
    |> Perspective.Core.UserPool.put!()
  end
end
