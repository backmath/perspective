defmodule Core.ToDoAdded.Test do
  use ExUnit.Case

  test "builds a struct" do
    assert %Core.ToDoAdded{
      id: "123",
      name: "Hello"
    }
  end

  test "apply the event" do
    event = %Core.ToDoAdded{
      id: "todo:abc-123",
      name: "Hello"
    }

    result = Core.ToDoAdded.Applier.apply_to(%Core.ToDo{}, event)
  end
end
