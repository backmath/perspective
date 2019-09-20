defmodule Perspective.ToDoReactor.Test do
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
    |> Perspective.Core.ToDo.Reactor.send()

    :timer.sleep(10)

    result = Perspective.Core.ToDoPool.get("todo/abc-123")

    expected = %Perspective.Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Example todo",
      creator_id: "user/abc-123"
    }

    assert {:ok, expected} == result
  end

  test "reactor updates to Perspective.Core.ToDoRenamed" do
    %Perspective.Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Example todo"
    }
    |> Perspective.Core.ToDoPool.put()

    %Perspective.Core.ToDoRenamed{data: %{todo_id: "todo/abc-123", name: "Renamed todo"}}
    |> Perspective.Core.ToDo.Reactor.send()

    :timer.sleep(10)

    result = Perspective.Core.ToDoPool.get("todo/abc-123")

    expected = %Perspective.Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Renamed todo"
    }

    assert {:ok, expected} == result
  end

  test "reactor updates to Perspective.Core.ToDoCompleted" do
    %Perspective.Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Example todo"
    }
    |> Perspective.Core.ToDoPool.put()

    %Perspective.Core.ToDoCompleted{data: %{todo_id: "todo/abc-123"}}
    |> Perspective.Core.ToDo.Reactor.send()

    :timer.sleep(10)

    result = Perspective.Core.ToDoPool.get("todo/abc-123")

    expected = %Perspective.Core.ToDo{
      completed: true,
      id: "todo/abc-123",
      name: "Example todo"
    }

    assert {:ok, expected} == result
  end
end
