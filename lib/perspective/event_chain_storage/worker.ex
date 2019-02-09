defmodule Perspective.EventChainStorageWorker do
  use GenServer

  def start_link(data) do
    GenServer.start_link(__MODULE__, data, name: __MODULE__)
  end

  def init(_data) do
    Phoenix.PubSub.subscribe(Perspective.EventChainNotifications, "new_event")

    initial_state = %{}
    {:ok, initial_state}
  end

  # Needs a test
  def handle_info(data, state) do
    Perspective.EventChainStorage.save()
    {:noreply, state}
  end
end
