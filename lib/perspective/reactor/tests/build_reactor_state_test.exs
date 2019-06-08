defmodule Perspective.Reactor.BuildReactorState.Test do
  use ExUnit.Case, async: true

  setup_all do
    case Perspective.Reactor.TestExample.Supervisor.start_link() do
      {:ok, _pid} -> :ok
    end
  end

  setup do
    Perspective.EventChain.Reset.start_new_chain()
    Perspective.Reactor.TestExample.reset()
    Perspective.Reactor.BackupState.save_state(Perspective.Reactor.TestExample, Perspective.Reactor.TestExample.state())
  end

  test "initial reactor state" do
    assert_correct_initial_state()
  end

  test "reset() reloading from a new chain" do
    copy_sample_event_chain()

    assert_correct_initial_state()

    Perspective.Reactor.TestExample.reset()

    expected_state = %Perspective.Reactor.State{
      data: %Perspective.Reactor.TestExample.State{value: 3},
      last_event_processed: "event/3"
    }

    assert expected_state == Perspective.Reactor.TestExample.state()
  end

  test "reset() reloading from a backup" do
    copy_sample_backup_state()

    assert_correct_initial_state()

    Perspective.Reactor.TestExample.Supervisor.reboot()

    expected_state = %Perspective.Reactor.State{
      data: %Perspective.Reactor.TestExample.State{value: 77},
      last_event_processed: nil
    }

    assert expected_state == Perspective.Reactor.TestExample.state()
  end

  defp assert_correct_initial_state do
    expected_state = %Perspective.Reactor.State{
      data: %Perspective.Reactor.TestExample.State{
        value: 0
      },
      last_event_processed: nil
    }

    assert expected_state == Perspective.Reactor.TestExample.state()
  end

  defp copy_sample_event_chain do
    File.copy!(
      "./lib/perspective/reactor/tests/data/event-chain-manifest.json",
      Perspective.StorageConfig.path("event-chain-manifest.json")
    )

    File.copy!(
      "./lib/perspective/reactor/tests/data/event-chain.0000000.json",
      Perspective.StorageConfig.path("event-chain.0000000.json")
    )
  end

  defp copy_sample_backup_state do
    File.copy!(
      "./lib/perspective/reactor/tests/data/Perspective.Reactor.TestExample.json",
      Perspective.StorageConfig.path("Perspective.Reactor.TestExample.json")
    )
  end
end
