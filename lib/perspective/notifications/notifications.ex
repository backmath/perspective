defmodule Perspective.Notifications do
  def subscribe(%event_name{}) do
    Phoenix.PubSub.subscribe(__MODULE__, to_string(event_name))
  end

  def emit(%event_name{} = event) do
    Phoenix.PubSub.broadcast!(__MODULE__, to_string(event_name), event)
  end
end
