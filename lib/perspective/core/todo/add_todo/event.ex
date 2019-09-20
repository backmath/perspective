defmodule Perspective.Core.ToDoAdded do
  use Perspective.DomainEvent

  @action_request Perspective.Core.AddToDo

  defmodule Data do
    defstruct [:todo_id, :name]
  end
end
