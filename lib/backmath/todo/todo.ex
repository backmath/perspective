defmodule BackMath.ToDo do
  defstruct [:id, :name]

  defprotocol BackMath.ToDoAdded.Appliable do
    def apply(node, event)
  end

  # defimpl BackMath.ToDoRemoved.Appliable do
  #   def apply(node, event) do
  #   end
  # end
end
