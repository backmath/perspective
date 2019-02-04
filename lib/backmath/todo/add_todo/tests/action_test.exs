defmodule BackMath.AddToDo.Test do
  use ExUnit.Case

  test "builds a struct" do
    result = BackMath.AddToDo.new(name: "Hello")

    assert %BackMath.AddToDo{name: "Hello"} == result
  end
end
