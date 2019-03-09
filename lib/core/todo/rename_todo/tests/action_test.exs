defmodule Core.RenameToDo.Test do
  use ExUnit.Case

  test "transforms into an event" do
    event = Core.RenameToDo.transform(valid_action())

    assert %Core.ToDoRenamed{todo_id: "todo:abc-123", name: "Demonstrate a Valid RenameToDo Action"} = event
  end

  test "name is required" do
    result =
      valid_action()
      |> Map.put(:name, "")
      |> Core.RenameToDo.valid?()

    assert false == result
  end

  test "todo_id is required" do
    result =
      valid_action()
      |> Map.put(:todo_id, "")
      |> Core.RenameToDo.valid?()

    assert false == result
  end

  test "the valid action is indeed valid" do
    assert Core.RenameToDo.valid?(valid_action())
  end

  defp valid_action do
    %Core.RenameToDo{
      todo_id: "todo:abc-123",
      name: "Demonstrate a Valid RenameToDo Action"
    }
  end
end
