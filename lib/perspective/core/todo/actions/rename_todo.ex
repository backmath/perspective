defmodule Perspective.Core.RenameToDo do
  use Perspective.ActionRequest

  domain_event(Perspective.Core.ToDoRenamed, "1.0")

  validate_syntax(%{data: data}) do
    Vex.errors(data,
      todo_id: [presence: true],
      name: [presence: true]
    )
  end
end
