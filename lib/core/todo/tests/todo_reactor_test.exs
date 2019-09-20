defmodule Perspective.ToDoReactor.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  setup(context) do
    Core.ToDo.Reactor.Supervisor.start_link(context)
    :ok
  end

  test "reactor updates to Core.ToDoAdded" do
    %Core.ToDoAdded{
      actor_id: "user/abc-123",
      data: %{todo_id: "todo/abc-123", name: "Example todo"}
    }
    |> Core.ToDo.Reactor.send()

    :timer.sleep(10)

    result = Perspective.DomainPool.get("todo/abc-123")

    expected = %Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Example todo",
      creator_id: "user/abc-123"
    }

    assert {:ok, expected} == result
  end

  test "reactor updates to Core.ToDoRenamed" do
    %Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Example todo"
    }
    |> Perspective.DomainPool.put()

    %Core.ToDoRenamed{data: %{todo_id: "todo/abc-123", name: "Renamed todo"}}
    |> Core.ToDo.Reactor.send()

    :timer.sleep(10)

    result = Perspective.DomainPool.get("todo/abc-123")

    expected = %Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Renamed todo"
    }

    assert {:ok, expected} == result
  end

  test "reactor updates to Core.ToDoCompleted" do
    %Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Example todo"
    }
    |> Perspective.DomainPool.put()

    %Core.ToDoCompleted{data: %{todo_id: "todo/abc-123"}}
    |> Core.ToDo.Reactor.send()

    :timer.sleep(10)

    result = Perspective.DomainPool.get("todo/abc-123")

    expected = %Core.ToDo{
      completed: true,
      id: "todo/abc-123",
      name: "Example todo"
    }

    assert {:ok, expected} == result
  end
end
