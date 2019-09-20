defmodule Perspective.Core.ToDoRenamed do
  use Perspective.DomainEvent

  @action_request Perspective.Core.ToDoRenamed

  defmodule V2 do
    defstruct [:todo_id, :name]
  end

  defmodule V1 do
    defstruct [:todo_id, :name]
  end
end
