defmodule BackMath.AddToDo do
  use Perspective.Action

  defstruct [:name]

  def new(data) do
    struct(__MODULE__, data)
  end

  transform(action) do
    %BackMath.ToDoAdded{
      id: UUID.uuid4(),
      name: action.name
    }
  end
end
