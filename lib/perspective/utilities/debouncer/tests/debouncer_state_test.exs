defmodule Perspective.Debouncer.State.Test do
  use ExUnit.Case, async: true

  test "toggle function readiness" do
    state = Perspective.Debouncer.State.new()

    assert :ready == Perspective.Debouncer.State.condition(state)

    state = Perspective.Debouncer.State.start_debouncing(state)
    assert :debouncing == Perspective.Debouncer.State.condition(state)

    state = Perspective.Debouncer.State.require_a_recall(state)
    assert :recall_when_done == Perspective.Debouncer.State.condition(state)

    state = Perspective.Debouncer.State.start_debouncing(state)
    assert :debouncing == Perspective.Debouncer.State.condition(state)
  end
end
