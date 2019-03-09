defmodule Core.CompleteToDo.Test do
  use ExUnit.Case

  test "transforms into an event" do
    event = Core.CompleteToDo.transform(valid_action())

    assert %Core.ToDoCompleted{
             todo_id: "todo:abc-123",
             date: event_date
           } = event

    {:ok, event_date, 0} = DateTime.from_iso8601(event_date)
    expected_date = DateTime.utc_now()

    assert DateTime.diff(expected_date, event_date, :microsecond) < 10_000
  end

  test "todo_id is required" do
    result =
      valid_action()
      |> Map.put(:todo_id, "")
      |> Core.CompleteToDo.valid?()

    assert false == result
  end

  test "the valid action is indeed valid" do
    assert Core.CompleteToDo.valid?(valid_action())
  end

  defp valid_action do
    %Core.CompleteToDo{
      todo_id: "todo:abc-123"
    }
  end
end
