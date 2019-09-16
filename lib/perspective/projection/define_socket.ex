defmodule Perspective.Projection.DefineSocket do
  def define(exposures, reactor, caller) do
    genserver_name = Module.concat(reactor, ProjectionSocket)

    definition =
      quote bind_quoted: [exposures: exposures, reactor: reactor] do
        use Phoenix.Socket

        Enum.map(exposures, fn {path, module} ->
          Phoenix.Socket.channel(path, Module.concat(module, ProjectionSocket))
        end)

        def connect(params, socket, connect_info) do
          {:ok, socket}
        end

        def id(_socket), do: nil
      end

    Module.create(genserver_name, definition, Macro.Env.location(caller))
  end
end
