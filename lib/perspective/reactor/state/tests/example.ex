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
