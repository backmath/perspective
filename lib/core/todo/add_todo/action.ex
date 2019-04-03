defmodule Core.AddToDo do
  use Perspective.ActionRequest

  @domain_event Core.ToDoAdded

  validate_syntax(%{data: data}) do
    Vex.errors(data, name: [presence: true])
  end
end
