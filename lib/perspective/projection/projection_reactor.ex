defmodule Perspective.ProjectionReactor do
  use Agent

  def init(data) do
    Perspective.Notifications.subscribe(%Perspective.Reactor.ReactorUpdated{})

    {:ok, data}
  end

  def start_link(_data) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start do
    start_link(nil)
  end

  def handle_info(%Perspective.Reactor.ReactorUpdated{module: module} = _data, state) do
    data = module.get

    channels_for_reactor(module)
    |> Enum.each(fn channel ->
      Web.Endpoint.broadcast!(channel.path(), "update", data)
    end)

    {:noreply, state}
  end

  defp channels_for_reactor(module) do
    [Core.Projections.SystemTime.Channel]
  end
end
