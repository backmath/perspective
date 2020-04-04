defmodule Perspective.Reactor.API.Test do
  use ExUnit.Case, async: true

  defmodule ExampleEvent do
    defstruct data: :b
  end

  defmodule Example do
    use Perspective.Reactor

    initial_state do
      [:a]
    end

    update(%ExampleEvent{} = event, state) do
      [event.data | state]
    end
  end

  defmodule DefaultReactor do
    use Perspective.Reactor
  end

  test "initial_state macro generates module function correctly" do
    assert [:a] == Perspective.Reactor.API.Test.Example.initial_state()
  end

  test "update macro generates correctly and yields expected value" do
    assert [:b, :a] == Perspective.Reactor.API.Test.Example.update(%ExampleEvent{}, [:a])
  end

  test "subscribed_events returns the event  yields expected value" do
    assert [Perspective.Reactor.API.Test.ExampleEvent] = Perspective.Reactor.API.Test.Example.updateable_events()
  end

  test "a reactors default initial state is nil" do
    assert nil == Perspective.Reactor.API.Test.DefaultReactor.initial_state()
  end

  test "run_update throws an error for unsupported events" do
    assert_raise Perspective.Reactor.UnsupportedEvent, fn ->
      Perspective.Reactor.API.Test.Example.update(:unsupported, [:a])
    end
  end
end
