defmodule BackMath.CompleteToDo.Test do
  use ExUnit.Case

  test "transforms into an event" do
    event = BackMath.CompleteToDo.transform(valid_action())

    assert %BackMath.ToDoCompleted{
             id: "todo:abc-123",
             date: event_date
           } = event

    {:ok, event_date, 0} = DateTime.from_iso8601(event_date)
    expected_date = DateTime.utc_now()

    assert DateTime.diff(expected_date, event_date, :microsecond) < 10_000
  end

  test "id is required" do
    result =
      valid_action()
      |> Map.put(:id, "")
      |> BackMath.CompleteToDo.valid?()

    assert false == result
  end

  test "the valid action is indeed valid" do
    assert BackMath.CompleteToDo.valid?(valid_action())
  end

  defp valid_action do
    %BackMath.CompleteToDo{
      id: "todo:abc-123"
    }
  end
end
