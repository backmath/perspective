defmodule Perspective.Core.RenameToDo do
  use Perspective.ActionRequest
  use Perspective.ActionRequest.RejectAnonymousUsers

  @domain_event Perspective.Core.ToDoRenamed

  validate_syntax(%{data: data}) do
    Vex.errors(data,
      todo_id: [presence: true],
      name: [presence: true]
    )
  end
end
