defmodule Perspective.Debouncer.State.Test do
  use ExUnit.Case

  test "basic function call" do
    state = Perspective.Debouncer.State.new()

    state = Perspective.Debouncer.State.register(state, :hello, fn -> "Hello, test" end)

    function = Perspective.Debouncer.State.fetch_function(state, :hello)

    assert "Hello, test" == function.()
  end

  test "toggle function readiness" do
    state =
      Perspective.Debouncer.State.new()
      |> Perspective.Debouncer.State.register(:hello, fn -> nil end)

    assert :ready == Perspective.Debouncer.State.condition(state, :hello)

    state = Perspective.Debouncer.State.start_debouncing(state, :hello)
    assert :debouncing == Perspective.Debouncer.State.condition(state, :hello)

    state = Perspective.Debouncer.State.require_a_recall(state, :hello)
    assert :recall_when_done == Perspective.Debouncer.State.condition(state, :hello)

    state = Perspective.Debouncer.State.make_function_ready(state, :hello)
    assert :ready == Perspective.Debouncer.State.condition(state, :hello)
  end

  test "calling condition/fetch_function with an undefined function_key throws an appropriate error" do
    empty_state = Perspective.Debouncer.State.new()

    assert_raise(Perspective.Debouncer.MissingFunctionKey, fn ->
      Perspective.Debouncer.State.condition(empty_state, :missing_key)
    end)

    assert_raise(Perspective.Debouncer.MissingFunctionKey, fn ->
      Perspective.Debouncer.State.fetch_function(empty_state, :missing_key)
    end)
  end
end
