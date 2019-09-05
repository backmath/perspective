defmodule Core.User.Reactor do
  use Perspective.Reactor

  update(%Core.UserAdded{data: data}, _state) do
    %Core.User{}
    |> Map.put(:id, data.user_id)
    |> Map.put(:username, data.username)
    |> Map.put(:password_hash, data.password_hash)
    |> Perspective.DomainPool.put!()
  end
end
