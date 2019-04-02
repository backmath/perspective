defmodule Perspective.InvalidAction.Test do
  use ExUnit.Case

  test "raising a InvalidAction error provides a helpful message" do
    expected_message = "The action (Elixir.Core.AddToDo) is invalid (to enumerate later)."

    assert_raise(Perspective.Action.InvalidAction, expected_message, fn ->
      action = Core.AddToDo.new(%{})
      raise Perspective.Action.InvalidAction, {action, []}
    end)
  end
end
