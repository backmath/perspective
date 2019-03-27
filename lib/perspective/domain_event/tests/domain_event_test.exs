defmodule Perspective.DomainEvent.Test do
  use ExUnit.Case

  test "from_map" do
    data = %{
      id: "event:def-456",
      actor_id: "user:abc-123",
      event_type: "Core.ToDoAdded",
      event_date: "2019-03-09T22:26:02.940566Z",
      data: %{
        name: "Demonstrate a Saved Event",
        todo_id: "todo:hij-789"
      },
      meta: %{
        request_date: "2019-03-09T22:26:02.840566Z"
      }
    }

    expected = %Core.ToDoAdded{
      id: "event:def-456",
      actor_id: "user:abc-123",
      event_date: DateTime.from_iso8601("2019-03-09T22:26:02.940566Z") |> elem(1),
      data: %Core.ToDoAdded.Data{
        name: "Demonstrate a Saved Event",
        todo_id: "todo:hij-789"
      },
      meta: %{
        request_date: DateTime.from_iso8601("2019-03-09T22:26:02.840566Z") |> elem(1)
      }
    }

    result = Perspective.DomainEventTransformers.from_map(data)

    assert expected == result
  end

  test "to_map" do
    data = %Core.ToDoAdded{
      id: "event:def-456",
      actor_id: "user:abc-123",
      event_date: DateTime.from_iso8601("2019-03-09T22:26:02.940566Z") |> elem(1),
      data: %Core.ToDoAdded.Data{
        name: "Demonstrate a Saved Event",
        todo_id: "todo:hij-789"
      },
      meta: %{
        request_date: DateTime.from_iso8601("2019-03-09T22:26:02.840566Z") |> elem(1)
      }
    }

    expected = %{
      id: "event:def-456",
      actor_id: "user:abc-123",
      event_type: "Core.ToDoAdded",
      event_date: DateTime.from_iso8601("2019-03-09T22:26:02.940566Z") |> elem(1),
      data: %{
        name: "Demonstrate a Saved Event",
        todo_id: "todo:hij-789"
      },
      meta: %{
        request_date: DateTime.from_iso8601("2019-03-09T22:26:02.840566Z") |> elem(1)
      }
    }

    result = Perspective.DomainEventTransformers.to_map(data)

    assert expected == result
  end
end
