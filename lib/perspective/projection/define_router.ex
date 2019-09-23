defmodule Perspective.Projection.DefineRouter do
  def define(exposures, module, caller) do
    module_name = Perspective.ProjectionNames.router(module)

    definition =
      quote bind_quoted: [exposures: exposures, module: module] do
        use Phoenix.Router, namespace: nil

        Enum.map(exposures, fn {path, controller} ->
          Phoenix.Router.get(path, controller, :index)
        end)
      end

    Module.create(module_name, definition, Macro.Env.location(caller))

    module_name
  end
end
