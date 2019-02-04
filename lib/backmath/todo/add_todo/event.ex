defmodule BackMath.ToDoAdded do
  defstruct [:id, :name]

  defprotocol Appliable do
    def apply(node, event)
  end
end

defmodule ToDo do
  defimpl BackMath.ToDoAdded.Appliable do
    def apply(node, event) do
    end
  end
end
