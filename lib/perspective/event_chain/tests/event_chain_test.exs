defmodule Perspective.EventChain.Test do
  use ExUnit.Case

  setup do
    Perspective.EventChain.load([])

    on_exit(fn ->
      Perspective.EventChain.load([])
    end)
  end

  test "you can list events since a hash" do
    Perspective.EventChain.load([
      %Core.ToDoAdded{id: "event:jkl"},
      %Core.ToDoAdded{id: "event:ghi"},
      %Core.ToDoAdded{id: "event:def"},
      %Core.ToDoAdded{id: "event:abc"}
    ])

    expected = [
      %Core.ToDoAdded{id: "event:ghi"},
      %Core.ToDoAdded{id: "event:jkl"}
    ]

    assert expected == Perspective.EventChain.since("event:def")
  end

  test "you can stream all of the events" do
    Perspective.EventChain.load([
      %Core.ToDoAdded{id: "event:def"},
      %Core.ToDoAdded{id: "event:abc"}
    ])

    expected = [
      %Core.ToDoAdded{id: "event:def"},
      %Core.ToDoAdded{id: "event:abc"}
    ]

    assert expected == Perspective.EventChain.list()
  end
end
