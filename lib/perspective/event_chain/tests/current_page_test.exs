defmodule Perspective.EventChain.CurrentPage.Test do
  use ExUnit.Case

  test "initial load" do
    Perspective.EventChain.Reset.start_new_chain()

    assert %Perspective.EventChain.CurrentPage.State{events: events} = Perspective.EventChain.CurrentPage.get()

    assert events == []
  end

  test "writing an event" do
    Perspective.EventChain.Reset.start_new_chain()

    Core.AddToDo.new(%{name: "Example Event"})
    |> Perspective.DomainEvent.RequestTransformer.to_event()
    |> Perspective.EventChain.CurrentPage.add()

    Process.sleep(10)

    assert 49 == Perspective.EventChain.CurrentPage.event_count_remaining()
    assert false == Perspective.EventChain.CurrentPage.is_full?()
  end
end
