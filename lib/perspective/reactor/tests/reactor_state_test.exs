defmodule Perspective.Reactor.State.Test do
  use ExUnit.Case

  defmodule Example do
    defstruct [:id]
  end

  test "reactor state initialization" do
    state = Perspective.Reactor.State.new()

    from_state = Perspective.Reactor.State.from(last_event_processed: "event:abc-123", data: :something)

    assert %Perspective.Reactor.State{data: nil, last_event_processed: nil} == state
    assert %Perspective.Reactor.State{last_event_processed: "event:abc-123", data: :something} == from_state
  end

  test "reactor state updates" do
    state = Perspective.Reactor.State.new()

    new_state = Perspective.Reactor.State.update(state, :something, %Example{id: "event:abc-123"})

    assert %Perspective.Reactor.State{data: :something, last_event_processed: "event:abc-123"} == new_state
  end
end
