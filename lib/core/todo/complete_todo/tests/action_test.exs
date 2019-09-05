defmodule Core.CompleteToDo.Test do
  use ExUnit.Case, async: true

  test "validate_syntax returns an empty list for a valid action" do
    assert [] = Core.CompleteToDo.validate_syntax(Core.CompleteToDo.new(%{todo_id: "todo:abc-123"}))
  end

  test "validate_syntax requires a todo_id" do
    result =
      Core.CompleteToDo.new(%{})
      |> Core.CompleteToDo.validate_syntax()

    assert [{:error, :todo_id, :presence, "must be present"}] == result
  end

  test "domain_event is as expected" do
    assert Core.ToDoCompleted == Core.CompleteToDo.domain_event()
  end
end
