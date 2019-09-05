defmodule Core.ToDoRemoved.Test do
  use ExUnit.Case, async: true

  test "builds a struct" do
    assert %Core.ToDoRemoved{
      data: %{
        todo_id: "todo:abc-123"
      }
    }
  end
end
