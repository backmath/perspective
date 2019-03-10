defmodule Perspective.EventChain.Test do
  use ExUnit.Case

  setup do
    Perspective.EventChain.load([])
  end

  test "you can add events to the event chain" do
    event = %Perspective.DomainEvent{}

    :ok = Perspective.EventChain.apply_event(event)

    assert event == Perspective.EventChain.last()
  end

  test "you can list events since a hash" do
    Perspective.EventChain.apply_event(%Perspective.DomainEvent{event_id: "event:abc"})
    Perspective.EventChain.apply_event(%Perspective.DomainEvent{event_id: "event:def"})
    Perspective.EventChain.apply_event(%Perspective.DomainEvent{event_id: "event:ghi"})
    Perspective.EventChain.apply_event(%Perspective.DomainEvent{event_id: "event:jkl"})

    expected = [
      %Perspective.DomainEvent{event_id: "event:ghi"},
      %Perspective.DomainEvent{event_id: "event:jkl"}
    ]

    assert expected == Perspective.EventChain.since("event:def")
  end

  test "you can stream all of the events" do
    Perspective.EventChain.apply_event(%Perspective.DomainEvent{event_id: "event:abc"})
    Perspective.EventChain.apply_event(%Perspective.DomainEvent{event_id: "event:def"})

    expected = [
      %Perspective.DomainEvent{event_id: "event:def"},
      %Perspective.DomainEvent{event_id: "event:abc"}
    ]

    assert expected == Perspective.EventChain.list()
  end
end
