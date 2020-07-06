defmodule Perspective.Reactor.API.Test do
  use Perspective.TestCase

  defmodule DefaultReactor do
    use Perspective.Reactor
  end

  defmodule Example do
    use Perspective.Reactor

    defmodule Event do
      defstruct data: :b
    end

    initial_state do
      [:a]
    end

    update(%Example.Event{} = event, state) do
      [event.data | state]
    end
  end

  test "a reactor's default initial state is nil" do
    assert nil == Perspective.Reactor.API.Test.DefaultReactor.initial_state()
  end

  test "a reactor's initial state can be defined by calling the initial_state macro" do
    assert [:a] == Perspective.Reactor.API.Test.Example.initial_state()
  end

  test "a reactor transforms received events and state as defined by calling the update macro" do
    assert [:b, :a] == Perspective.Reactor.API.Test.Example.update(%Example.Event{}, [:a])
  end

  test "subscribed_events returns all events registered through Reactor.update" do
    assert [Perspective.Reactor.API.Test.Example.Event] = Perspective.Reactor.API.Test.Example.updateable_events()
  end

  test "sending an event not supported throws an error (should not happen in practice)" do
    assert_raise Perspective.Reactor.UnsupportedEvent, fn ->
      Perspective.Reactor.API.Test.Example.update(:unsupported, [:a])
    end
  end
end
