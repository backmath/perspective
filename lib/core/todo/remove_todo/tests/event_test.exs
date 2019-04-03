defmodule Core.ToDoRemoved.Test do
  use ExUnit.Case

  test "builds a struct" do
    assert %Core.ToDoRemoved{
      data: %{
        todo_id: "todo:abc-123"
      }
    }
  end
end
