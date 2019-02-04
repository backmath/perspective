defmodule BackMath.ToDoAdded.Test do
  use ExUnit.Case

  test "builds a struct" do
    assert %BackMath.ToDoAdded{
      id: "123",
      name: "Hello"
    }
  end
end
