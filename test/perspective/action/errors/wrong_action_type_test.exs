defmodule Perspective.WrongActionType.Test do
  use ExUnit.Case

  defmodule ActionExample do
    defstruct [:id]
  end

  defmodule ExpectedExample do
    defstruct [:id]
  end

  test "raising a WrongActionType error provides a helpful message" do
    expected_message =
      "You have supplied Elixir.Perspective.WrongActionType.Test.ActionExample, but this module only accepts Elixir.Perspective.WrongActionType.Test.ExpectedExample"

    assert_raise(Perspective.Action.WrongActionType, expected_message, fn ->
      raise(Perspective.Action.WrongActionType, {%ActionExample{}, ExpectedExample})
    end)
  end
end
