defmodule BackMath.RemoveToDo.Test do
  use ExUnit.Case

  test "transforms into an event" do
    event = BackMath.RemoveToDo.transform(valid_action())

    assert %BackMath.ToDoRemoved{id: "todo:abc-123"} = event
  end

  test "id is required" do
    result =
      valid_action()
      |> Map.put(:id, "")
      |> BackMath.RemoveToDo.valid?()

    assert false == result
  end

  test "the valid action is indeed valid" do
    assert BackMath.RemoveToDo.valid?(valid_action())
  end

  defp valid_action do
    %BackMath.RemoveToDo{
      id: "todo:abc-123"
    }
  end
end
