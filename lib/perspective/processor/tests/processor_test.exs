defmodule Perspective.Processor.Test do
  use ExUnit.Case

  test "example run" do
    Core.AddToDo.new(%{
      name: "Test Perspective.Processor.run"
    })
    |> Perspective.Processor.run()

    result = Perspective.EventChain.last()

    assert %Core.ToDoAdded{data: %{name: "Test Perspective.Processor.run"}} = result
  end
end
