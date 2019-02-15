defmodule Core.RemoveToDo do
  use Perspective.Action

  defstruct id: ""

  validates(:id, presence: true)

  transform(action) do
    %Core.ToDoRemoved{
      id: action.id
    }
  end
end
