defmodule Perspective.ToDoReactor.Test do
  use ExUnit.Case

  test "reactor updates to Core.ToDoAdded" do
    Perspective.DomainPool.delete(%{id: "todo/abc-123"})

    %Core.ToDoAdded{data: %{todo_id: "todo/abc-123", name: "Example todo"}}
    |> Core.ToDo.Reactor.send()

    :timer.sleep(10)

    result = Perspective.DomainPool.get("todo/abc-123")

    expected = %Core.ToDo{
      completed: false,
      id: "todo/abc-123",
      name: "Example todo"
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
end
