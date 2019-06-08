defmodule Perspective.Reactor.TestExample do
  use Perspective.Reactor

  defmodule State do
    defstruct value: 0
  end

  defmodule Increment do
    defstruct id: ""
  end

  initial_state do
    %State{}
  end

  update(%Increment{}, state) do
    %State{value: state.value + 1}
  end
end

defmodule Perspective.Reactor.TestReactor do
  use Perspective.Reactor

  defmodule ExampleEvent do
    defstruct data: :b
  end

  defmodule ReverseReverse do
    defstruct data: nil
  end

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
