defmodule Perspective.EventChainStorage.Test do
  use ExUnit.Case

  setup do
    File.mkdir_p!(test_path())
    []
  end

  test "backup saves an copy to the filesystem" do
    event = %Core.ToDoAdded{
      domain_event_id: "domain_event:abc-123",
      domain_event_date: "2019-03-09T22:26:02.940566Z",
      todo_id: "todo:def-456",
      name: "Demonstrate a Saved Event"
    }

    Perspective.EventChain.load([event])
    Perspective.EventChainStorage.save(test_file())

    assert "[{\"domain_event_date\":\"2019-03-09T22:26:02.940566Z\",\"domain_event_id\":\"domain_event:abc-123\",\"event\":\"Elixir.Core.ToDoAdded\",\"name\":\"Demonstrate a Saved Event\",\"todo_id\":\"todo:def-456\"}]" ==
             File.read!(test_file())
  end

  defp test_file do
    "#{test_path()}event-chain.json"
  end

  defp test_path do
    "./storage/test/tmp/Perspective.EventChainStorage/"
  end
end
