defmodule Core.ToDoCompleted do
  use Perspective.DomainEvent

  @action_request Core.CompleteToDo

  defmodule Data do
    defstruct [:todo_id, :date]
  end
end
