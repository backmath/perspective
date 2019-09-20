defmodule Perspective.Core.RenameToDo.Test do
  use ExUnit.Case, async: true

  test "validate_syntax returns an empty list for a valid action" do
    result =
      Perspective.Core.RenameToDo.new("user/abc-123", %{
        todo_id: "todo:abc-123",
        name: "Demonstrate a Valid RenameToDo Action"
      })
      |> Perspective.Core.RenameToDo.validate_syntax()

    assert [] == result
  end

  test "name is required" do
    result =
      Perspective.Core.RenameToDo.new("user/abc-123", %{
        todo_id: "todo:abc-123"
      })
      |> Perspective.Core.RenameToDo.validate_syntax()

    assert [{:error, :name, :presence, "must be present"}] == result
  end

  test "todo_id is required" do
    result =
      Perspective.Core.RenameToDo.new("user/abc-123", %{
        name: "Demonstrate a Valid RenameToDo Action"
      })
      |> Perspective.Core.RenameToDo.validate_syntax()

    assert [{:error, :todo_id, :presence, "must be present"}] == result
  end

  test "domain_event is as expected" do
    assert Perspective.Core.ToDoRenamed == Perspective.Core.RenameToDo.domain_event()
  end
end
