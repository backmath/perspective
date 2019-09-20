defmodule Core.RemoveToDo.Test do
  use ExUnit.Case, async: true

  test "validate_syntax returns an empty list for a valid action" do
    result =
      Core.RemoveToDo.new("user/abc-123", %{
        todo_id: "todo:abc-123"
      })
      |> Core.RemoveToDo.validate_syntax()

    assert [] == result
  end

  test "validate_syntax requires a todo_id" do
    result =
      Core.RemoveToDo.new(%{
        todo_id: ""
      })
      |> Core.RemoveToDo.validate_syntax()

    assert [{:error, :todo_id, :presence, "must be present"}] == result
  end

  test "domain_event is as expected" do
    assert Core.ToDoRemoved == Core.RemoveToDo.domain_event()
  end
end
