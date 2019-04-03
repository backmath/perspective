defmodule Core.ToDoRenamed do
  use Perspective.DomainEvent

  @action_request Core.ToDoRenamed

  defmodule Data do
    defstruct [:todo_id, :name]
  end
end
