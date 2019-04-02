defmodule Perspective.Processor.Test do
  use ExUnit.Case

  test "example run" do
    assert {:ok, _action} = Perspective.Processor.run(action_request())

    result = Perspective.EventChain.last()

    assert %Core.ToDoAdded{data: %{name: "Test Perspective.Processor.run"}} = result
  end

  defp action_request do
    Core.AddToDo.new(%{
      name: "Test Perspective.Processor.run"
    })
  end
end
