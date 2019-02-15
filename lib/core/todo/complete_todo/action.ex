defmodule Core.CompleteToDo do
  use Perspective.Action

  defstruct id: ""

  validates(:id, presence: true)

  transform(action) do
    %Core.ToDoCompleted{
      id: action.id,
      date: DateTime.utc_now() |> DateTime.to_iso8601()
    }
  end
end
