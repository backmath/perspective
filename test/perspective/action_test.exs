defmodule Perspective.ActionTestExample do
  use Perspective.Action

  defaction(id: "", name: "")

  transform(action) do
    {:ok, %{some: :transformation, data: action}}
  end
end

defmodule Perspective.NonCompliantExample do
  use Perspective.Action

  defaction(id: "", name: "")
end

defmodule Perspective.ActionTest do
  use ExUnit.Case
  alias Perspective.ActionTestExample, as: Subject

  test "transformation macro" do
    action = %Perspective.ActionTestExample{id: "abc-123"}

    assert {:ok, %{some: :transformation, data: action}} == Subject.transform(action)
  end

  test "transformation fails with wrong type" do
    assert_raise(Perspective.Action.WrongActionType, fn ->
      action = %Perspective.NonCompliantExample{}
      Perspective.ActionTestExample.transform(action)
    end)
  end

  test "transformation fails with a missing definition" do
    action = %Perspective.NonCompliantExample{id: "abc-123"}

    assert_raise(Perspective.Action.UndefinedTransformationFunction, fn ->
      Perspective.NonCompliantExample.transform(action)
    end)
  end

  test "an action 'uses' vex struct" do
    action = %Perspective.ActionTestExample{id: "abc-123"}
    assert Vex.valid?(action)
  end

  test "defaction creates a struct with additional [:actor, :request, :request_date, :references] keys" do
    keys =
      %Perspective.ActionTestExample{id: "abc-123"}
      |> Map.keys()

    assert Enum.member?(keys, :actor)
    assert Enum.member?(keys, :request)
    assert Enum.member?(keys, :request_date)
    assert Enum.member?(keys, :references)
  end

  test "defaction throws a helpful message if provided a non-keyword-list" do
    assert_raise(ArgumentError, fn ->
      defmodule Example do
        use Perspective.Action
        defaction([:id])
      end
    end)
  end
end
