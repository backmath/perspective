defmodule Core.ToDoAdded do
  use Perspective.DomainEvent

  defstruct [:todo_id, :name]
end

defprotocol Core.ToDoAdded.Applier do
  def apply_to(node, event)
end

defimpl Core.ToDoAdded.Applier, for: Core.ToDo do
  def apply_to(node, event) do
    Map.merge(node, event)
  end
end
