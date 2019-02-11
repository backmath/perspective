defmodule Perspective.EventChainNotifications do
  def subscribe() do
  end

  defmodule NewEvent do
    defstruct [:event]
  end

  def emit("NewEvent", event) do
    event = %NewEvent{
      event: event
    }

    Phoenix.PubSub.broadcast(__MODULE__, "NewEvent", event)
  end
end
