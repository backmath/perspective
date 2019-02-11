defmodule BackMath.RenameToDo do
  use Perspective.Action

  defaction(id: "", name: "")

  validates(:id, presence: true)
  validates(:name, presence: true)

  transform(action) do
    %BackMath.ToDoRenamed{
      id: action.id,
      name: action.name
    }
  end
end
