defmodule Core.ToDo.Test do
  use ExUnit.Case

  test "apply_event: ToDoAdded " do
    todo = %Core.ToDo{}

    event = %Core.ToDoAdded{
      data: %{
        todo_id: "todo:abc-123",
        name: "Demonstrate ToDoAdded application"
      }
    }

    expected = %Core.ToDo{
      id: "todo:abc-123",
      name: "Demonstrate ToDoAdded application"
    }

    assert {:ok, result} = Core.ToDo.apply_event(todo, event)

    assert result == expected
  end

  test "apply_event: ToDoRenamed" do
    todo = %Core.ToDo{
      id: "todo:abc-123",
      name: "Something ToDo"
    }

    event = %Core.ToDoRenamed{
      todo_id: "todo:abc-123",
      name: "Demonstrate ToDoRenamed application"
    }

    expected = %Core.ToDo{
      id: "todo:abc-123",
      name: "Demonstrate ToDoRenamed application"
    }

    assert {:ok, result} = Core.ToDo.apply_event(todo, event)

    assert result == expected
  end

  test "apply_event: ToDoCompleted" do
    todo = %Core.ToDo{
      id: "todo:abc-123",
      name: "Demonstrate ToDoCompleted application"
    }

    event = %Core.ToDoCompleted{
      todo_id: "todo:abc-123"
    }

    expected = %Core.ToDo{
      id: "todo:abc-123",
      name: "Demonstrate ToDoCompleted application",
      completed: true
    }

    assert {:ok, result} = Core.ToDo.apply_event(todo, event)

    assert result == expected
  end
end
