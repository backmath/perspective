defmodule Perspective.EventChain.CurrentPage.State.Test do
  use ExUnit.Case, async: true

  test "new" do
    assert %Perspective.EventChain.CurrentPage.State{events: []} == Perspective.EventChain.CurrentPage.State.new()
  end

  test "add an event" do
    state = Perspective.EventChain.CurrentPage.State.new()

    result = Perspective.EventChain.CurrentPage.State.add(state, %{some: :event})

    assert %Perspective.EventChain.CurrentPage.State{events: [%{some: :event}]} = result
  end

  test "add a list of events" do
    state = Perspective.EventChain.CurrentPage.State.new()

    result = Perspective.EventChain.CurrentPage.State.add(state, [%{some: :event}, %{some: :other_event}])

    assert %Perspective.EventChain.CurrentPage.State{events: [%{some: :event}, %{some: :other_event}]} = result
  end

  test "event_count_remaining" do
    state = Perspective.EventChain.CurrentPage.State.new()

    result = Perspective.EventChain.CurrentPage.State.event_count_remaining(state)

    assert 50 == result
  end

  test "is_full? returns false when under the configured value" do
    state =
      Perspective.EventChain.CurrentPage.State.new()
      |> Perspective.EventChain.CurrentPage.State.add(List.duplicate(nil, 49))

    result = Perspective.EventChain.CurrentPage.State.is_full?(state)

    assert false == result
  end

  test "is_full? returns true when at the configured value" do
    state =
      Perspective.EventChain.CurrentPage.State.new()
      |> Perspective.EventChain.CurrentPage.State.add(List.duplicate(nil, 50))

    result = Perspective.EventChain.CurrentPage.State.is_full?(state)

    assert true == result
  end

  test "is_full? returns true when over the configured value" do
    state =
      Perspective.EventChain.CurrentPage.State.new()
      |> Perspective.EventChain.CurrentPage.State.add(List.duplicate(nil, 51))

    result = Perspective.EventChain.CurrentPage.State.is_full?(state)

    assert true == result
  end
end
