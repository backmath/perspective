defmodule Perspective.Projection.InitialStateUndefined.Test do
  use ExUnit.Case

  test "raising a InitialStateUndefined error provides a helpful message" do
    expected_message = "The module Elixir.Something is a Perspective.Projection, but it does not define initial_state"

    assert_raise(Perspective.Projection.InitialStateUndefined, expected_message, fn ->
      raise(Perspective.Projection.InitialStateUndefined, Something)
    end)
  end
end
