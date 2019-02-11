defmodule BackMath.RenameToDo.Test do
  use ExUnit.Case

  test "transforms into an event" do
    event = BackMath.RenameToDo.transform(valid_action())

    assert %BackMath.ToDoRenamed{id: "todo:abc-123", name: "Demonstrate a Valid RenameToDo Action"} = event
  end

  test "name is required" do
    result =
      valid_action()
      |> Map.put(:name, "")
      |> BackMath.RenameToDo.valid?()

    assert false == result
  end

  test "id is required" do
    result =
      valid_action()
      |> Map.put(:id, "")
      |> BackMath.RenameToDo.valid?()

    assert false == result
  end

  test "the valid action is indeed valid" do
    assert BackMath.RenameToDo.valid?(valid_action())
  end

  defp valid_action do
    %BackMath.RenameToDo{
      id: "todo:abc-123",
      name: "Demonstrate a Valid RenameToDo Action"
    }
  end
end
