defmodule Perspective.Processor.Test do
  use ExUnit.Case

  test "example run" do
    action = %BackMath.AddToDo{name: "Test Perspective.Processor.run"}

    assert {:ok, action} == Perspective.Processor.run(action)

    assert %BackMath.ToDoAdded{name: "Test Perspective.Processor.run"} = Perspective.EventChain.last()
  end
end
