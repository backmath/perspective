defmodule Perspective.Core.ToDoRemoved do
  use Perspective.DomainEvent

  defmodule Data do
    defstruct [:todo_id]
  end
end
