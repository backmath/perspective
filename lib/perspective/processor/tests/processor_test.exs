defmodule Perspective.Processor.Test do
  use ExUnit.Case

  test "example run" do
    assert {:ok, _action} = Perspective.Processor.run(action_request())

    result = Perspective.EventChain.last()

    assert %Core.ToDoAdded{name: "Test Perspective.Processor.run"} = result.event
  end

  defp action_request do
    Perspective.RequestGenerator.from(%{
      action: "Core.AddToDo",
      data: %{
        name: "Test Perspective.Processor.run"
      }
    })
  end
end
