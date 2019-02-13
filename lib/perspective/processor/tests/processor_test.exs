defmodule Perspective.Processor.Test do
  use ExUnit.Case

  test "example run" do
    assert {:ok, _action} = Perspective.Processor.run(action_request())

    assert %BackMath.ToDoAdded{name: "Test Perspective.Processor.run"} = Perspective.EventChain.last()
  end

  defp action_request do
    Perspective.Request.from(%{
      request: "request:abc-123",
      actor: "user:john-adams",
      action: "BackMath.AddToDo",
      data: %{
        name: "Test Perspective.Processor.run"
      }
    })
  end
end