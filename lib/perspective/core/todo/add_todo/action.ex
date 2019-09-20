defmodule Perspective.Core.AddToDo do
  use Perspective.ActionRequest
  use Perspective.ActionRequest.RejectAnonymousUsers

  @domain_event Perspective.Core.ToDoAdded

  validate_syntax(%{data: data}) do
    Vex.errors(data, name: [presence: true])
  end

  authorize_request %{actor_id: _actor_id} do
    true
  end
end
