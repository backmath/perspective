defmodule Perspective.EventChain.Test do
  use ExUnit.Case

  setup do
    Perspective.EventChain.load([])
  end

  test "you can add events to the event chain" do
    event = %BackMath.ToDoAdded{}

    :ok = Perspective.EventChain.apply_event(event)

    assert event == Perspective.EventChain.last()
  end

  test "you can list events since a hash" do
    Perspective.EventChain.apply_event(%BackMath.ToDoAdded{id: "event:abc"})
    Perspective.EventChain.apply_event(%BackMath.ToDoAdded{id: "event:def"})
    Perspective.EventChain.apply_event(%BackMath.ToDoAdded{id: "event:ghi"})
    Perspective.EventChain.apply_event(%BackMath.ToDoAdded{id: "event:jkl"})

    expected = [
      %BackMath.ToDoAdded{id: "event:ghi"},
      %BackMath.ToDoAdded{id: "event:jkl"}
    ]

    assert expected == Perspective.EventChain.since("event:def")
  end

  test "you can stream all of the events" do
    Perspective.EventChain.apply_event(%BackMath.ToDoAdded{id: "event:abc"})
    Perspective.EventChain.apply_event(%BackMath.ToDoAdded{id: "event:def"})

    expected = [
      %BackMath.ToDoAdded{id: "event:def"},
      %BackMath.ToDoAdded{id: "event:abc"}
    ]

    assert expected == Perspective.EventChain.list()
  end
end
