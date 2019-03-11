defmodule Perspective.Reactor.Test do
  use ExUnit.Case

  defmodule ExampleEvent do
    defstruct data: :b
  end

  defmodule ReverseReverse do
    defstruct data: nil
  end

  defmodule Example do
    use Perspective.Reactor

    initial_state(backup_state) do
      [:a]
    end

    backup(_event, state) do
      state
    end

    update(%ExampleEvent{} = event, state) do
      [event.data | state]
    end

    update(%ReverseReverse{} = _event, state) do
      Enum.reverse(state)
    end
  end

  test "start a reactor and update to events" do
    Example.start()

    assert [:a] = Example.get()

    Perspective.Notifications.emit(%ExampleEvent{})

    assert [:b, :a] = Example.get()

    Perspective.Notifications.emit(%ReverseReverse{})

    assert [:a, :b] = Example.get()
  end

  test "start a reactor and backup to disk" do
    Example.start()

    case File.rm("./storage/test/Elixir.Perspective.Reactor.Test.Example.backup.json") do
      :ok -> :ok
      {:error, :enoent} -> :ok
    end

    Perspective.Notifications.emit(%ExampleEvent{})

    Process.sleep(5)

    assert "[\"a\"]" = File.read!("./storage/test/Elixir.Perspective.Reactor.Test.Example.backup.json")
  end
end
