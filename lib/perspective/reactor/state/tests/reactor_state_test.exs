defmodule Perspective.Reactor.State.Test do
  use ExUnit.Case, async: true

  defmodule Example do
    defstruct [:id]
  end

  test "reactor state can be initialized from existing data" do
    state = Perspective.Reactor.State.from(last_event_processed: "event:abc-123", data: :something)

    assert %Perspective.Reactor.State{last_event_processed: "event:abc-123", data: :something} == state
  end

  test "updating reactor state stores the new data" do
    state = Perspective.Reactor.State.new()

    new_state = Perspective.Reactor.State.update(state, :something, %Example{id: "event:abc-123"})

    assert %Perspective.Reactor.State{data: :something} = new_state
  end

  test "updating reactor state stores the id of the last event processed" do
    state = Perspective.Reactor.State.new()

    new_state = Perspective.Reactor.State.update(state, :something, %Example{id: "event:abc-123"})

    assert %Perspective.Reactor.State{last_event_processed: "event:abc-123"} = new_state
  end
end
