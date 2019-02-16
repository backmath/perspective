defmodule Core.RemoveToDo.Test do
  use ExUnit.Case

  test "transforms into an event" do
    event = Core.RemoveToDo.transform(valid_action())

    assert %Core.ToDoRemoved{id: "todo:abc-123"} = event
  end

  test "id is required" do
    result =
      valid_action()
      |> Map.put(:id, "")
      |> Core.RemoveToDo.valid?()

    assert false == result
  end

  test "the valid action is indeed valid" do
    assert Core.RemoveToDo.valid?(valid_action())
  end

  defp valid_action do
    %Core.RemoveToDo{
      id: "todo:abc-123"
    }
  end
end