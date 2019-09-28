defmodule Perspective.Core.RemoveToDo.Test do
  use ExUnit.Case, async: true

  test "validate_syntax returns an empty list for a valid action" do
    result =
      Perspective.Core.RemoveToDo.new("user/abc-123", %{
        todo_id: "todo:abc-123"
      })
      |> Perspective.Core.RemoveToDo.validate_syntax()

    assert [] == result
  end

  test "validate_syntax requires a todo_id" do
    result =
      Perspective.Core.RemoveToDo.new(%{
        todo_id: ""
      })
      |> Perspective.Core.RemoveToDo.validate_syntax()

    assert [{:error, :todo_id, :presence, "must be present"}] == result
  end

  test "action requests transform to a domain event as expected" do
    event =
      Perspective.Core.RemoveToDo.new("user/abc-123", %{todo_id: "todo:abc-123"})
      |> Perspective.Processor.RequestTransformer.transform()

    assert %Perspective.Core.ToDoRemoved{version: "1.0"} = event
  end
end
