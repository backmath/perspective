defmodule Core.RemoveToDo do
  use Perspective.Action

  defaction(id: "")

  validates(:id, presence: true)

  transform(action) do
    %Core.ToDoRemoved{
      id: action.id
    }
  end
end
