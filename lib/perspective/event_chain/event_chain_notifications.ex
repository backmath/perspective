# defmodule Perspective.EventChainNotifications do
#   def subscribe() do
#   end

#   def emit(topic, event) do
#     Phoenix.PubSub.broadcast(__MODULE__, topic, event)
#   end
# end

defmodule Perspective.EventChainBackup do
  # use Perspective.PubSubSubscriber, to: Perspective.EventChainNotifications

  def backup do
    Perspective.EventChain.list()
    |> Enum.map(fn %event_type{} = data ->
      Map.merge(data, %{event: event_type})
      |> Map.delete(:__struct__)
    end)
    |> Jason.encode!()
  end

  # handle(event) do
  #   Perspective.EventChain.since()
  # end
end
