defmodule Perspective.Reactor.API.Test do
  use ExUnit.Case

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

  test "initial_state generated from a macro" do
    assert [:a] == Perspective.Reactor.API.Test.Example.initial_state()
  end

  test "update generated from a macro" do
    assert [:b, :a] == Perspective.Reactor.API.Test.Example.update(%ExampleEvent{}, [:a])
  end

  test "default initial_state is nil" do
    assert nil == Perspective.Reactor.API.Test.DefaultReactor.initial_state()
  end

  test "run_update throws an error for unsupported events" do
    assert_raise Perspective.Reactor.UnsupportedEvent, fn ->
      Perspective.Reactor.API.Test.Example.update(:unsupported, [:a])
    end
  end

  test "subscribed_events generated from a macro" do
    assert [Perspective.Reactor.API.Test.ExampleEvent] = Perspective.Reactor.API.Test.Example.updateable_events()
  end

  # test "backup_disabled" do
  #   assert true == Perspective.Reactor.API.Test.Example.backup_enabled?()
  #   assert false == Perspective.Reactor.API.Test.AnotherExample.backup_enabled?()
  # end
end
