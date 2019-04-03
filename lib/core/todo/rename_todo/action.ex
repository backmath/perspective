defmodule Core.RenameToDo do
  use Perspective.ActionRequest

  @domain_event Core.ToDoRenamed

  validate_syntax(%{data: data}) do
    Vex.errors(data,
      todo_id: [presence: true],
      name: [presence: true]
    )
  end
end
