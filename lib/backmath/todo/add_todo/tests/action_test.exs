defmodule BackMath.AddToDo.Test do
  use ExUnit.Case

  test "transforms into an event" do
    event = BackMath.AddToDo.transform(valid_action())

    assert %BackMath.ToDoAdded{name: "Demonstrate a Valid AddToDo Action"} = event
  end

  test "name is required" do
    result =
      valid_action()
      |> Map.put(:name, "")
      |> BackMath.AddToDo.valid?()

    assert false == result
  end

  test "the valid action is indeed valid" do
    assert BackMath.AddToDo.valid?(valid_action())
  end

  defp valid_action do
    %BackMath.AddToDo{
      name: "Demonstrate a Valid AddToDo Action"
    }
  end
end
