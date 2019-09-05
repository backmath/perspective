defmodule Perspective.ProjectionReactor do
  use Perspective.GenServer

  def start do
    start_link(nil)
  end

  # def handle_info(%Perspective.Reactor.ReactorUpdated{module: module, pid: pid} = _data, state) do
  #   # @todo: improve error handling for dead reactors
  #   data =
  #     case Process.alive?(pid) do
  #       true -> module.get
  #       false -> %{}
  #     end

  #   channels_for_reactor(module)
  #   |> Enum.each(fn {path, _channel, _reactor} ->
  #     Web.Endpoint.broadcast!(path, "update", data)
  #   end)

  #   {:noreply, state}
  # end

  # defp channels_for_reactor(module) do
  #   Perspective.ProjectionRegistry.projections()
  #   |> Enum.filter(fn {_path, _channel, reactor} -> reactor == module end)
  # end
end
