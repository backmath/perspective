defmodule Perspective.Core.ToDoRemoved.Test do
  use ExUnit.Case, async: true

  test "builds a struct" do
    assert %Perspective.Core.ToDoRemoved{
      data: %{
        todo_id: "todo:abc-123"
      }
    }
  end
end
