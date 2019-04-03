defmodule Core.ToDoRemoved do
  use Perspective.DomainEvent

  @action_request Core.AddUser

  defmodule Data do
    defstruct [:todo_id]
  end
end
