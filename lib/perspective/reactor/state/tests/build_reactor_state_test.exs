defmodule Perspective.Reactor.BuildReactorState.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "initial reactor state", context do
    Perspective.Reactor.TestExample.Supervisor.start_link(context)

    assert_correct_initial_state()
  end

  test "loading from a new chain", context do
    copy_sample_event_chain()

    Perspective.Reactor.TestExample.Supervisor.start_link(context)

    expected_state = %Perspective.Reactor.State{
      data: %Perspective.Reactor.TestExample.State{value: 3},
      last_event_processed: "event/3"
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
end
