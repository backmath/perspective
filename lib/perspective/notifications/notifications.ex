defmodule Perspective.Notifications do
  def start_link(opts) do
    GenServer.start(Phoenix.PubSub.PG2, opts, name: name())
  end

  def subscribe(event) do
    Phoenix.PubSub.subscribe(name(), topic_name(event))
  end

  def subscribe(event, id) do
    Phoenix.PubSub.subscribe(name(), topic_name(event, id))
  end

  def emit(event) do
    Phoenix.PubSub.broadcast!(name(), topic_name(event), event)
  end

  def emit(event, id) do
    Phoenix.PubSub.broadcast!(name(), topic_name(event, id), event)
  end

  def name do
    app_id = Perspective.AppID.fetch_and_set()

    {:global, name} = Perspective.GenServer.Names.name(Perspective.Notifications, app_id: app_id)

    String.to_atom(name)
  end

  defp topic_name(%event_name{}), do: to_string(event_name)
  defp topic_name(%event_name{}, nil = _id), do: to_string(event_name)
  defp topic_name(%event_name{}, id), do: "#{to_string(event_name)}.#{id}"
end
