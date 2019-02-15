defmodule Core.ToDoAdded.Test do
  use ExUnit.Case

  test "builds a struct" do
    assert %Core.ToDoAdded{
      id: "123",
      name: "Hello"
    }
  end
end
