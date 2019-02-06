defmodule BackMath.AddToDo do
  defstruct [:name]

  def new(data) do
    struct(__MODULE__, data)
  end

  defimpl Perspective.ActionTransformer do
    def transform(action) do
      %BackMath.ToDoAdded{
        id: UUID.uuid4(),
        name: action.name
      }
    end
  end
end
