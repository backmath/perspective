defmodule Perspective.Projection.DefineController do
  def define(path, reactor, caller) do
    module_name = Perspective.ProjectionNames.controller(reactor)

    definition =
      quote bind_quoted: [path: path, reactor: reactor] do
        use Phoenix.Controller
        import Perspective.ModuleRegistry
        register_module(Perspective.ProjectionController)

        def index(conn, _params) do
          data = unquote(reactor).data()
          json(conn, data)
        end

        def path, do: unquote(path)
      end

    Module.create(module_name, definition, Macro.Env.location(caller))

    module_name
  end
end
