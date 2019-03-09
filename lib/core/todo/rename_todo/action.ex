defmodule Core.RenameToDo do
  use Perspective.Action

  defstruct todo_id: "", name: ""

  validates(:todo_id, presence: true)
  validates(:name, presence: true)

  transform(action) do
    %Core.ToDoRenamed{
      todo_id: action.todo_id,
      name: action.name
    }
  end
end
