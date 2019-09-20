defmodule Perspective.Core.ToDoAdded do
  use Perspective.DomainEvent

  @action_request Perspective.Core.AddToDo

  defmodule Data do
    defstruct [:todo_id, :name]
  end

  transform_data(%{data: data}) do
    Map.put(data, :todo_id, Perspective.Core.ToDo.generate_id())
  end
end
