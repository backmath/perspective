defmodule Perspective.Core.RemoveToDo do
  use Perspective.ActionRequest
  use Perspective.ActionRequest.RejectAnonymousUsers

  domain_event(Perspective.Core.ToDoRemoved, "1.0")

  validate_syntax(%{data: data}) do
    Vex.errors(data, todo_id: [presence: true])
  end
end
