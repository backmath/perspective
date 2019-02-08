defmodule Perspective.EventChainStorage.Test do
  use ExUnit.Case

  setup do
    File.mkdir_p!(test_path())
    []
  end

  test "backup saves an copy to the filesystem" do
    Perspective.EventChain.load([%BackMath.ToDoAdded{}])
    Perspective.EventChainStorage.save(test_file())

    assert "[{\"event\":\"Elixir.BackMath.ToDoAdded\",\"id\":null,\"name\":null}]" == File.read!(test_file())
  end

  defp test_file do
    "#{test_path()}event-chain.json"
  end

  defp test_path do
    "./storage/test/tmp/Perspective.EventChainStorage/"
  end
end
