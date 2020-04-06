defmodule Perspective.Reactor.Test do
  use Perspective.TestCase

  setup context do
    {:ok, pid} = Perspective.Reactor.TestReactor.Supervisor.start_link(context)

    [supervisor: pid]
  end

  test "start a reactor and update to events" do
    Perspective.Notifications.subscribe(%Perspective.Reactor.TestReactor.StateUpdated{})

    assert [:a] = Perspective.Reactor.TestReactor.data()

    Perspective.Reactor.TestReactor.send(%Perspective.Reactor.TestReactor.ExampleEvent{})

    assert [:b, :a] = Perspective.Reactor.TestReactor.data()

    Perspective.Reactor.TestReactor.send(%Perspective.Reactor.TestReactor.ReverseReverse{})

    assert [:a, :b] = Perspective.Reactor.TestReactor.data()

    assert_receive %Perspective.Reactor.TestReactor.StateUpdated{}
  end
end
