defmodule Perspective.Core.DomainPool.NodeNotFound.Test do
  use ExUnit.Case, async: true

  test "raising a NodeNotFound error provides a helpful message" do
    expected_message = "The domain node (abc-123) could not be found"

    assert_raise(Perspective.Core.DomainPool.NodeNotFound, expected_message, fn ->
      raise Perspective.Core.DomainPool.NodeNotFound, "abc-123"
    end)
  end
end
