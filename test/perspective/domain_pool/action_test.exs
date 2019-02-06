defmodule Perspective.ActionTestExample do
  use Perspective.Action

  defstruct [:id, :name]

  transform(action) do
    {:ok, %{some: :transformation, data: action}}
  end
end

defmodule Perspective.NonCompliantExample do
  use Perspective.Action

  defstruct [:id, :name]
end

defmodule Perspective.ActionTest do
  use ExUnit.Case
  alias Perspective.ActionTestExample, as: Subject

  test "transformation macro" do
    action = %Perspective.ActionTestExample{id: "abc-123"}

    assert {:ok, %{some: :transformation, data: action}} == Subject.transform(action)
  end

  test "transformation fails with wrong type" do
    assert_raise(
      Perspective.Action.WrongActionTypeError,
      "You have supplied Elixir.Perspective.NonCompliantExample, but this module only accepts Elixir.Perspective.ActionTestExample",
      fn ->
        action = %Perspective.NonCompliantExample{}
        Perspective.ActionTestExample.transform(action)
      end
    )
  end

  test "transformation fails with a missing definition" do
    action = %Perspective.NonCompliantExample{id: "abc-123"}

    assert_raise(
      Perspective.Action.UndefinedTransformationFunction,
      "You have not defined a transformation function for Elixir.Perspective.NonCompliantExample",
      fn ->
        Perspective.NonCompliantExample.transform(action)
      end
    )
  end
end
