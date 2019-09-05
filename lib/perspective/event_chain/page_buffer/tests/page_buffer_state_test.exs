defmodule Perspective.EventChain.PageBuffer.State.Test do
  use ExUnit.Case, async: true
  alias Perspective.EventChain.PageBuffer.State

  test "new" do
    assert %State{events: []} == State.new()
  end

  test "add" do
    result =
      State.new()
      |> State.add(%{some: :event})

    assert %State{events: [%{some: :event}]} == result
  end

  test "has_events returns false for empty state" do
    assert false == State.new() |> State.has_events?()

    result =
      State.new()
      |> State.add(%{some: :event})

    assert %State{events: [%{some: :event}]} == result
  end

  test "has_events returns true for non-empty state" do
    state =
      State.new()
      |> State.add(%{some: :event})

    assert true == State.has_events?(state)
  end

  test "take_out returns empty results when called against empty state" do
    {state, events} =
      State.new()
      |> State.take_out(10)

    assert [] == events
    assert %State{events: []} == state
  end

  test "take_out returns the requested amount and leaves the remainder" do
    state =
      State.new()
      |> State.add(%{some: :event})
      |> State.add(%{some: :other_event})

    {state, events} = State.take_out(state, 1)

    assert [%{some: :event}] == events
    assert %State{events: [%{some: :other_event}]} == state
  end

  test "take_out returns everything and leaves nothing when requesting in excess" do
    state =
      State.new()
      |> State.add(%{some: :event})
      |> State.add(%{some: :other_event})

    {state, events} = State.take_out(state, 3)

    assert [%{some: :event}, %{some: :other_event}] == events
    assert %State{events: []} == state
  end
end
