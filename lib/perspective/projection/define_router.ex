defmodule Perspective.Projection.DefineRouter do
  def define(exposures, module, caller) do
    genserver_name = Module.concat(module, ProjectionRouter)

    definition =
      quote bind_quoted: [exposures: exposures, module: module] do
        use Phoenix.Router, namespace: nil

        Enum.map(exposures, fn {path, reactor} ->
          Module.concat(reactor, ProjectionController)

          Phoenix.Router.get(path, Module.concat(reactor, ProjectionController), :index)
        end)
      end

    Module.create(genserver_name, definition, Macro.Env.location(caller))
  end
end
