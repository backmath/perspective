defmodule BackMath.CompleteToDo do
  use Perspective.Action

  defaction(id: "")

  validates(:id, presence: true)

  transform(action) do
    %BackMath.ToDoCompleted{
      id: action.id,
      date: DateTime.utc_now() |> DateTime.to_iso8601()
    }
  end
end
