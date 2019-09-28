defmodule Perspective.Core.CompleteToDo.Test do
  use ExUnit.Case, async: true

  test "validate_syntax returns an empty list for a valid action" do
    action = Perspective.Core.CompleteToDo.new("user/abc-123", %{todo_id: "todo:abc-123"})

    assert [] = Perspective.Core.CompleteToDo.validate_syntax(action)
  end

  test "validate_syntax requires a todo_id" do
    result =
      Perspective.Core.CompleteToDo.new(%{})
      |> Perspective.Core.CompleteToDo.validate_syntax()

    assert [{:error, :todo_id, :presence, "must be present"}] == result
  end

  test "action requests transform to a domain event as expected" do
    event =
      Perspective.Core.CompleteToDo.new("user/abc-123", %{todo_id: "todo:abc-123"})
      |> Perspective.Processor.RequestTransformer.transform()

    assert %Perspective.Core.ToDoCompleted{version: "1.0"} = event
  end
end
