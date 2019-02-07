defmodule Perspective.NodeNotFound.Test do
  use ExUnit.Case

  test "raising a NodeNotFound error provides a helpful message" do
    expected_message = "The domain node (abc-123) could not be found"

    assert_raise(Perspective.NodeNotFound, expected_message, fn ->
      raise Perspective.NodeNotFound, "abc-123"
    end)
  end
end
