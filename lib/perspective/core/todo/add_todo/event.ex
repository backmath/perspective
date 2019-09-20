defmodule Perspective.Core.ToDoAdded do
  use Perspective.DomainEvent

  defmodule Data do
    defstruct [:todo_id, :name]
  end
end
