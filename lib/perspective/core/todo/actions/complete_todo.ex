defmodule Perspective.Core.CompleteToDo do
  use Perspective.ActionRequest

  domain_event(Perspective.Core.ToDoCompleted, "1.0")

  validate_syntax(%{data: data}) do
    Vex.errors(data, todo_id: [presence: true])
  end

  authorize(%{actor_id: actor_id, data: %{todo_id: todo_id}}) do
    %{creator_id: creator_id} = Perspective.Core.ToDos.find(todo_id)

    unless creator_id == actor_id do
      {:error, %Perspective.Unauthorized{}}
    end
  end
end
