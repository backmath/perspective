defmodule BackMath.ToDoCompleted.Test do
  use ExUnit.Case

  test "builds a struct" do
    assert %BackMath.ToDoCompleted{
      id: "todo:abc-123",
      date: "2019-02-11T16:22:08.144843Z"
    }
  end
end