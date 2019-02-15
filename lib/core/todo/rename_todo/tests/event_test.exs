defmodule Core.ToDoRenamed.Test do
  use ExUnit.Case

  test "builds a struct" do
    assert %Core.ToDoRenamed{
      id: "123",
      name: "Hello"
    }
  end
end
