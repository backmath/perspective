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

  test "@disabled_backups configuration" do
    defmodule DefaultBackupExample do
      use Perspective.Reactor
    end

    assert :none == DefaultBackupExample.disabled_backups()

    defmodule AllBackupsDisabledExample do
      use Perspective.Reactor

      @disabled_backups :all
    end

    assert :all == AllBackupsDisabledExample.disabled_backups()

    defmodule RegularBackupsDisabledExample do
      use Perspective.Reactor

      @disabled_backups :regular
    end

    assert :regular == RegularBackupsDisabledExample.disabled_backups()

    defmodule CrashBackupsDisabledExample do
      use Perspective.Reactor

      @disabled_backups :crash
    end

    assert :crash == CrashBackupsDisabledExample.disabled_backups()
  end

  test "@disabled_backups rejects invalid values" do
    assert_raise Perspective.Reactor.InvalidDisabledBackupsConfiguration, fn ->
      defmodule InvalidBackupsDisabledExample do
        use Perspective.Reactor

        @disabled_backups :invalid
      end
    end
  end
end
