defmodule Perspective.Core.ToDoRenamed do
  use Perspective.DomainEvent

  @action_request Perspective.Core.ToDoRenamed

  defmodule Data do
    defstruct [:todo_id, :name]
  end
end
