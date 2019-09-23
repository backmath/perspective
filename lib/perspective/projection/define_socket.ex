defmodule Perspective.Projection.DefineSocket do
  def define(exposures, reactor, caller) do
    module_name = Perspective.ProjectionNames.socket(reactor)

    definition =
      quote bind_quoted: [exposures: exposures, reactor: reactor] do
        use Phoenix.Socket

        Enum.map(exposures, fn {path, channel} ->
          Phoenix.Socket.channel(path, channel)
        end)

        def connect(params, socket, connect_info) do
          {:ok, socket}
        end

        def id(_socket), do: nil
      end

    Module.create(module_name, definition, Macro.Env.location(caller))

    module_name
  end
end
