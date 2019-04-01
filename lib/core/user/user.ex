defmodule Core.User do
  use Perspective.DomainNode

  defstruct id: "", username: ""

  def apply_event(_todo, %Core.UserAdded{} = event) do
    %Core.User{}
    |> Map.put(:id, event.data.user_id)
    |> Map.put(:username, event.data.username)
    |> case do
      new_todo -> {:ok, new_todo}
    end
  end
end
