defmodule Perspective.Projection.DefineChannel do
  def define(path, reactor, caller) do
    module_name = Perspective.ProjectionNames.channel(reactor)

    definition =
      quote bind_quoted: [path: path, reactor: reactor] do
        use Phoenix.Channel
        import Perspective.ModuleRegistry
        register_module(Perspective.ProjectionChannel)

        def join(path, _message, socket) do
          {:ok, socket}
        end

        def handle_in("get", _message, socket) do
          message = unquote(reactor).data()
          {:reply, {:ok, message}, socket}
        end

        def handle_in(unknown, payload, socket) do
          raise "You've attempted to use #{__MODULE__} with #{unknown}. Please fix"
        end
      end

    Module.create(module_name, definition, Macro.Env.location(caller))

    module_name
  end
end
