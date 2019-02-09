defmodule Perspective.EventChainNotifications do
  def subscribe() do
  end

  def emit("new_event", event) do
    Phoenix.PubSub.broadcast(__MODULE__, "new_event", event)
  end
end
