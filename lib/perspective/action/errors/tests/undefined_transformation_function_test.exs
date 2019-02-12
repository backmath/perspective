defmodule Perspective.UndefinedTransformationFunction.Test do
  use ExUnit.Case

  test "raising a UndefinedTransformationFunction error provides a helpful message" do
    expected_message =
      "You have not defined a transformation function for #{Perspective.UndefinedTransformationFunction.Test}"

    assert_raise(Perspective.Action.UndefinedTransformationFunction, expected_message, fn ->
      raise Perspective.Action.UndefinedTransformationFunction, __MODULE__
    end)
  end
end
