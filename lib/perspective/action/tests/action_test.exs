defmodule Perspective.ActionTestExample do
  use Perspective.Action

  defstruct example_id: "", name: ""

  transform(action) do
    %{some: :transformation, data: action}
  end
end

defmodule Perspective.NonCompliantExample do
  use Perspective.Action

  defstruct example_id: "", name: ""
end

defmodule Perspective.ActionTest do
  use ExUnit.Case
  alias Perspective.ActionTestExample, as: Subject

  test "transformation macro" do
    action = %Perspective.ActionTestExample{example_id: "abc-123"}

    assert %{some: :transformation, data: action} = Subject.transform(action)
  end

  test "transformation fails with wrong type" do
    assert_raise(Perspective.Action.WrongActionType, fn ->
      action = %Perspective.NonCompliantExample{}
      Perspective.ActionTestExample.transform(action)
    end)
  end

  test "transformation fails with a missing definition" do
    action = %Perspective.NonCompliantExample{example_id: "abc-123"}

    assert_raise(Perspective.Action.UndefinedTransformationFunction, fn ->
      Perspective.NonCompliantExample.transform(action)
    end)
  end

  test "an action 'uses' vex struct" do
    action = %Perspective.ActionTestExample{example_id: "abc-123"}
    assert Vex.valid?(action)
  end
end
