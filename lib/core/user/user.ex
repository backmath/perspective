defmodule Core.User do
  use Perspective.DomainNode

  defstruct id: "", username: ""

  def apply_event(_todo, %Core.UserAdded{} = event) do
    %Core.User{}
    |> Map.put(:id, event.user_id)
    |> Map.put(:username, event.username)
    |> case do
      new_todo -> {:ok, new_todo}
    end
  end
end
