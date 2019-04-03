defmodule Core.CompleteToDo do
  use Perspective.ActionRequest

  @domain_event Core.ToDoCompleted

  validate_syntax(%{data: data}) do
    Vex.errors(data, todo_id: [presence: true])
  end
end
