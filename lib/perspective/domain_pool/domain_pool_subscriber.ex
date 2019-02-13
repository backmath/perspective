defmodule Perspective.DomainPoolSubscriber do
  use Perspective.NotificationsSubscriber, name: Perspective.DomainPoolNotifications

  def handle_info(message, state) do
    {:noreply, state}
  end
end
