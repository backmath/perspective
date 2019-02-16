defmodule Core.RenameToDo do
  use Perspective.Action

  defstruct id: "", name: ""

  validates(:id, presence: true)
  validates(:name, presence: true)

  transform(action) do
    %Core.ToDoRenamed{
      id: action.id,
      name: action.name
    }
  end
end