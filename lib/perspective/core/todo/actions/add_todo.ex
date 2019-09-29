defmodule Perspective.Core.AddToDo do
  use Perspective.ActionRequest
  use Perspective.ActionRequest.RejectAnonymousUsers

  domain_event(Perspective.Core.ToDoAdded, "1.0")

  validate_syntax(%{data: data}) do
    Vex.errors(data, name: [presence: true])
  end

  authorize %{actor_id: _actor_id} do
    true
  end

  transform_data(%{data: data}) do
    Map.put(data, :todo_id, Perspective.Core.ToDo.generate_id())
  end
end
