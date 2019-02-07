defmodule BackMath.AddToDo do
  use Perspective.Action

  defstruct [:name]

  validates(:name, presence: true)

  transform(action) do
    %BackMath.ToDoAdded{
      id: UUID.uuid4(),
      name: action.name
    }
  end
end
