defmodule BackMath.ToDo.Test do
  use ExUnit.Case

  test "apply_event: ToDoAdded " do
    todo = %BackMath.ToDo{}

    event = %BackMath.ToDoAdded{
      id: "todo:abc-123",
      name: "Demonstrate ToDoAdded application"
    }

    expected = %BackMath.ToDo{
      id: "todo:abc-123",
      name: "Demonstrate ToDoAdded application"
    }

    assert {:ok, result} = BackMath.ToDo.apply_event(todo, event)

    assert result == expected
  end

  test "apply_event: ToDoRenamed" do
    todo = %BackMath.ToDo{
      id: "todo:abc-123",
      name: "Something ToDo"
    }

    event = %BackMath.ToDoRenamed{
      id: "todo:abc-123",
      name: "Demonstrate ToDoRenamed application"
    }

    expected = %BackMath.ToDo{
      id: "todo:abc-123",
      name: "Demonstrate ToDoRenamed application"
    }

    assert {:ok, result} = BackMath.ToDo.apply_event(todo, event)

    assert result == expected
  end

  test "apply_event: ToDoCompleted" do
    todo = %BackMath.ToDo{
      id: "todo:abc-123",
      name: "Demonstrate ToDoCompleted application"
    }

    event = %BackMath.ToDoCompleted{
      id: "todo:abc-123"
    }

    expected = %BackMath.ToDo{
      id: "todo:abc-123",
      name: "Demonstrate ToDoCompleted application",
      completed: true
    }

    assert {:ok, result} = BackMath.ToDo.apply_event(todo, event)

    assert result == expected
  end
end
