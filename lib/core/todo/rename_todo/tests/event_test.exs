defmodule Core.ToDoRenamed.Test do
  use ExUnit.Case

  test "builds a struct" do
    assert %Core.ToDoRenamed{
      todo_id: "123",
      name: "Hello"
    }
  end
end
