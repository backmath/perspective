defmodule Perspective.Reactor.BackupState.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "reactor state can be saved and reloaded" do
    state = Perspective.Reactor.State.from(last_event_processed: "event/abc-123", data: "abc")

    Perspective.Reactor.BackupState.save_state(Perspective.Reactor.BackupState, state)

    loaded_state = Perspective.Reactor.BackupState.load_state(Perspective.Reactor.BackupState)

    assert loaded_state == state
  end
end
