defmodule Perspective.Processor.Test do
  use ExUnit.Case

  test "example run" do
    assert {:ok, _action} = Perspective.Processor.run(action_request())

    expected = %Perspective.DomainEvent{
      event: %Core.ToDoAdded{name: "Test Perspective.Processor.run"}
    }

    assert expected = Perspective.EventChain.last()
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
