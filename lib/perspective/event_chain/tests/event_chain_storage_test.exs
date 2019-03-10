defmodule Perspective.EventChainStorage.Test do
  use ExUnit.Case

  setup do
    File.mkdir_p!(test_path())
    []
  end

  test "backup saves an copy to the filesystem" do
    # Convert from Core.ToDoAdded to Perspective.DomainEvent
    event = %Perspective.DomainEvent{
      event_date: "2019-03-09T22:26:02.940566Z",
      event_id: "event:abc-123",
      request_date: "2019-03-09T22:26:02.840566Z",
      event_type: "Core.ToDoAdded",
      event: %Core.ToDoAdded{
        todo_id: "todo:def-456",
        name: "Demonstrate a Saved Event"
      }
    }

    Perspective.EventChain.load([event])

    Perspective.EventChainStorage.save(test_file())

    assert "[{\"event\":{\"name\":\"Demonstrate a Saved Event\",\"todo_id\":\"todo:def-456\"},\"event_date\":\"2019-03-09T22:26:02.940566Z\",\"event_id\":\"event:abc-123\",\"event_type\":\"Core.ToDoAdded\",\"request_date\":\"2019-03-09T22:26:02.840566Z\"}]" ==
             File.read!(test_file())
  end

  defp test_file do
    "#{test_path()}event-chain.json"
  end

  defp test_path do
    "./storage/test/tmp/Perspective.EventChainStorage/"
  end
end
