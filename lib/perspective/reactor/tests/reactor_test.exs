defmodule Perspective.Reactor.Test do
  use ExUnit.Case

  setup_all do
    case Perspective.Reactor.TestReactor.Supervisor.start_link() do
      {:ok, _pid} -> :ok
    end
  end

  setup do
    Perspective.EventChain.Reset.start_new_chain()
    Process.sleep(25)
    Perspective.Reactor.TestReactor.reset()
  end

  test "start a reactor and update to events" do
    assert [:a] = Perspective.Reactor.TestReactor.data()

    Perspective.Reactor.TestReactor.send(%Perspective.Reactor.TestReactor.ExampleEvent{})

    assert [:b, :a] = Perspective.Reactor.TestReactor.data()

    Perspective.Reactor.TestReactor.send(%Perspective.Reactor.TestReactor.ReverseReverse{})

    assert [:a, :b] = Perspective.Reactor.TestReactor.data()
  end

  test "start a reactor and backup to disk" do
    assert [:a] = Perspective.Reactor.TestReactor.data()

    Perspective.Reactor.TestReactor.send(%Perspective.Reactor.TestReactor.ExampleEvent{data: :data})

    Process.sleep(75)

    path = Perspective.StorageConfig.path("Perspective.Reactor.TestReactor.json")

    assert "{\n  \"__perspective_struct__\": \"Perspective.Reactor.State\",\n  \"data\": [\n    \"data\",\n    \"a\"\n  ],\n  \"last_event_processed\": null\n}" =
             File.read!(path)
  end

  test "reset a Perspective.Reactor.TestReactor" do
    assert [:a] = Perspective.Reactor.TestReactor.data()

    Perspective.Reactor.TestReactor.send(%Perspective.Reactor.TestReactor.ExampleEvent{data: :data})

    assert [:data, :a] = Perspective.Reactor.TestReactor.data()

    Perspective.Reactor.TestReactor.reset()

    assert [:a] = Perspective.Reactor.TestReactor.data()
  end
end
