defmodule Perspective.Core.ToDos.Test do
  use ExUnit.Case, async: true
  use Perspective.SetUniqueAppID

  setup do
    Perspective.Core.start()
    :ok
  end

  test "reactor updates to Perspective.Core.ToDoAdded" do
    %Perspective.Core.ToDoAdded{
      actor_id: "user/abc-123",
      data: %{todo_id: "todo/abc-123", name: "Example todo"}
    }
    |> Perspective.Notifications.emit()

    result = Perspective.Core.ToDos.find("todo/abc-123")

    expected = %Perspective.Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Example todo",
      creator_id: "user/abc-123"
    }

    assert expected == result
  end

  test "reactor updates to Perspective.Core.ToDoRenamed" do
    %Perspective.Core.ToDoAdded{
      actor_id: "user/abc-123",
      data: %{todo_id: "todo/abc-123", name: "Example todo"}
    }
    |> Perspective.Notifications.emit()

    %Perspective.Core.ToDoRenamed{data: %{todo_id: "todo/abc-123", name: "Renamed todo"}}
    |> Perspective.Notifications.emit()

    result = Perspective.Core.ToDos.find("todo/abc-123")

    expected = %Perspective.Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Renamed todo",
      creator_id: "user/abc-123"
    }

    assert expected == result
  end

  test "reactor updates to Perspective.Core.ToDoCompleted" do
    %Perspective.Core.ToDoAdded{
      actor_id: "user/abc-123",
      data: %{todo_id: "todo/abc-123", name: "Example todo"}
    }
    |> Perspective.Notifications.emit()

    %Perspective.Core.ToDoCompleted{data: %{todo_id: "todo/abc-123"}}
    |> Perspective.Notifications.emit()

    result = Perspective.Core.ToDos.find("todo/abc-123")

    expected = %Perspective.Core.ToDo{
      completed: true,
      id: "todo/abc-123",
      name: "Example todo",
      creator_id: "user/abc-123"
    }

    assert expected == result
  end
end
