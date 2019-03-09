defmodule Core.RemoveToDo do
  use Perspective.Action

  defstruct todo_id: ""

  validates(:todo_id, presence: true)

  transform(action) do
    %Core.ToDoRemoved{
      todo_id: action.todo_id
    }
  end
end
