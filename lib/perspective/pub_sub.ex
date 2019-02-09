defmodule Perspective.PubSub do
  def emit(topic, data) do
    Phoenix.PubSub.broadcast(__MODULE__, topic, data)
  end
end
