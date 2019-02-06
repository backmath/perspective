defmodule BackMath.ToDo do
  use Perspective.DomainNode
  defstruct id: "", name: ""

  def new do
    %BackMath.ToDo{}
  end

  def apply_event(_node, %BackMath.ToDoAdded{} = event) do
    struct = %BackMath.ToDo{
      id: event.id,
      name: event.name
    }

    {:ok, struct}
  end
end
