defmodule Perspective.Reactor.BuildReactorState.Test do
  use Perspective.TestCase

  test "building reactor state from scratch uses initial_state" do
    state = Perspective.Reactor.BuildReactorState.build_from_scratch(Perspective.Reactor.TestExample)

    expected_state = %Perspective.Reactor.State{
      data: %Perspective.Reactor.TestExample.State{value: 0},
      last_event_processed: nil
    }

    assert state == expected_state
  end

  test "building reactor state from scratch processes the event chain" do
    copy_example_event_chain()

    state = Perspective.Reactor.BuildReactorState.build_from_scratch(Perspective.Reactor.TestExample)

    expected_state = %Perspective.Reactor.State{
      data: %Perspective.Reactor.TestExample.State{value: 3},
      last_event_processed: "event/3"
    }

    assert state == expected_state
  end

  test "building reactor from a backup loads from the saved file" do
    copy_example_backup_state_to_backup_location()

    state = Perspective.Reactor.BuildReactorState.build_from_backup(Perspective.Reactor.TestExample)

    expected_state = %Perspective.Reactor.State{
      data: %Perspective.Reactor.TestExample.State{value: 42},
      last_event_processed: nil
    }

    assert state == expected_state
  end

  test "building reactor from a backup processes the event chain" do
    copy_example_event_chain()
    copy_example_backup_state_to_backup_location()

    state = Perspective.Reactor.BuildReactorState.build_from_backup(Perspective.Reactor.TestExample)

    expected_state = %Perspective.Reactor.State{
      data: %Perspective.Reactor.TestExample.State{value: 45},
      last_event_processed: "event/3"
    }

    assert state == expected_state
  end

  defp copy_example_backup_state_to_backup_location do
    File.copy!(
      "./lib/perspective/reactor/state/tests/data/Perspective.Reactor.TestExample.json",
      Perspective.StorageConfig.path("Perspective.Reactor.TestExample.json")
    )
  end

  defp copy_example_event_chain do
    File.copy!(
      "./lib/perspective/reactor/tests/data/event-chain-manifest.json",
      Perspective.StorageConfig.path("event-chain-manifest.json")
    )

    File.copy!(
      "./lib/perspective/reactor/tests/data/event-chain.0000000.json",
      Perspective.StorageConfig.path("event-chain.0000000.json")
    )
  end
end
