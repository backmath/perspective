defmodule Perspective.Notifications do
  def subscribe(event) do
    Phoenix.PubSub.subscribe(__MODULE__, topic_name(event))
  end

  def subscribe(event, id) do
    Phoenix.PubSub.subscribe(__MODULE__, topic_name(event, id))
  end

  def emit(event) do
    Phoenix.PubSub.broadcast!(__MODULE__, topic_name(event), event)
  end

  def emit(event, id) do
    Phoenix.PubSub.broadcast!(__MODULE__, topic_name(event, id), event)
  end

  defp topic_name(%event_name{}), do: to_string(event_name)
  defp topic_name(%event_name{}, nil = _id), do: to_string(event_name)
  defp topic_name(%event_name{}, id), do: "#{to_string(event_name)}.#{id}"
end
