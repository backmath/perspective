defmodule Core.AddToDo.Test do
  use ExUnit.Case

  test "transforms into an event" do
    event = Core.AddToDo.transform(valid_action())

    assert %Core.ToDoAdded{data: %{name: "Demonstrate a Valid AddToDo Action"}} = event
  end

  test "name is required" do
    result =
      valid_action()
      |> Map.put(:name, "")
      |> Core.AddToDo.valid?()

    assert false == result
  end

  test "the valid action is indeed valid" do
    assert Core.AddToDo.valid?(valid_action())
  end

  defp valid_action do
    %Core.AddToDo{
      name: "Demonstrate a Valid AddToDo Action"
    }
  end
end
