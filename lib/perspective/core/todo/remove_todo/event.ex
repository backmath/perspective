defmodule Perspective.Core.ToDoRemoved do
  use Perspective.DomainEvent

  @action_request Perspective.Core.AddUser

  defmodule Data do
    defstruct [:todo_id]
  end
end
