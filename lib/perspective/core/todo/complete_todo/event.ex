defmodule Perspective.Core.ToDoCompleted do
  use Perspective.DomainEvent

  defmodule Data do
    defstruct [:todo_id, :date]
  end
end
