defmodule Perspective.Processor.Test do
  use ExUnit.Case

  test "example run" do
    action = %BackMath.AddToDo{name: "Test Perspective.Processor.run"}

    {:ok, [node]} = Perspective.Processor.run(action)

    assert %BackMath.ToDo{name: "Test Perspective.Processor.run"} = node
  end
end
