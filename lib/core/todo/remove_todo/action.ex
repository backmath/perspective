defmodule Core.RemoveToDo do
  use Perspective.ActionRequest

  @domain_event Core.ToDoRemoved

  validate_syntax(%{data: data}) do
    Vex.errors(data, todo_id: [presence: true])
  end
end
