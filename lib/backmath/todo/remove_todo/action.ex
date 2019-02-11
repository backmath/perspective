defmodule BackMath.RemoveToDo do
  use Perspective.Action

  defaction(id: "")

  validates(:id, presence: true)

  transform(action) do
    %BackMath.ToDoRemoved{
      id: action.id
    }
  end
end
