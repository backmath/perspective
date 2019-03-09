defmodule Core.CompleteToDo do
  use Perspective.Action

  defstruct todo_id: ""

  validates(:todo_id, presence: true)

  transform(action) do
    %Core.ToDoCompleted{
      todo_id: action.todo_id,
      date: DateTime.utc_now() |> DateTime.to_iso8601()
    }
  end
end
