defmodule BackMath.ToDoRenamed.Test do
  use ExUnit.Case

  test "builds a struct" do
    assert %BackMath.ToDoRenamed{
      id: "123",
      name: "Hello"
    }
  end
end
