defmodule Perspective.EventChainStorage.Test do
  use ExUnit.Case

  setup do
    File.mkdir_p!(test_path())
    []
  end

  test "backup saves an copy to the filesystem" do
    event = %Core.ToDoAdded{
      id: "event:def-456",
      actor_id: "user:abc-123",
      event_date: "2019-03-09T22:26:02.940566Z",
      data: %{
        todo_id: "todo:hij-789",
        name: "Demonstrate a Saved Event"
      },
      meta: %{
        event_id: "event:def-456"
      }
    }

    Perspective.EventChain.load([event])

    Perspective.EventChainStorage.save(test_file())

    assert "[{\"actor_id\":\"user:abc-123\",\"data\":{\"name\":\"Demonstrate a Saved Event\",\"todo_id\":\"todo:hij-789\"},\"event_date\":\"2019-03-09T22:26:02.940566Z\",\"event_type\":\"Core.ToDoAdded\",\"id\":\"event:def-456\",\"meta\":{\"event_id\":\"event:def-456\"}}]" ==
             File.read!(test_file())
  end

  defp test_file do
    "#{test_path()}event-chain.json"
  end

  defp test_path do
    "./storage/test/tmp/Perspective.EventChainStorage/"
  end
end
