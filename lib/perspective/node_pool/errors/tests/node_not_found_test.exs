defmodule Perspective.Core.DomainPool.NodeNotFound.Test do
  use ExUnit.Case, async: true

  test "raising a NodeNotFound error provides a helpful message" do
    expected_message = "The domain node (abc-123) could not be found in the pool (Elixir.SomeNodePool)"

    assert_raise(Perspective.NodePool.NodeNotFound, expected_message, fn ->
      raise Perspective.NodePool.NodeNotFound, {"abc-123", SomeNodePool}
    end)
  end
end
