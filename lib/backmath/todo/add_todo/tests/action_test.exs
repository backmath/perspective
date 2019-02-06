defmodule BackMath.AddToDo.Test do
  use ExUnit.Case

  test "builds a struct" do
    result = BackMath.AddToDo.new(name: "Hello")

    assert %BackMath.AddToDo{name: "Hello"} == result
  end

  test "transforms into an event" do
    event =
      %BackMath.AddToDo{name: "Hello"}
      |> Perspective.ActionTransformer.transform()

    assert %BackMath.ToDoAdded{name: "Hello"} = event
  end
end
