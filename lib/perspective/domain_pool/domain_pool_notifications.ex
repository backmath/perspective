defmodule Perspective.DomainPoolNotifications do
  def emit(node_id, event) do
    Phoenix.PubSub.broadcast(Perspective.DomainPoolNotifications, node_id, event)
  end
end
