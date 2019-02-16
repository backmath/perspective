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

    initial_state do
      [:a]
    end

    update(%ExampleEvent{} = event, state) do
      [event.data | state]
    end

    update(%ReverseReverse{} = _event, state) do
      Enum.reverse(state)
    end
  end

  test "start a reactor and update to events" do
    agent = Example.start()

    assert [:a] = Example.get()

    Perspective.Notifications.emit(%ExampleEvent{})

    assert [:b, :a] = Example.get()

    Perspective.Notifications.emit(%ReverseReverse{})

    assert [:a, :b] = Example.get()
  end
end
