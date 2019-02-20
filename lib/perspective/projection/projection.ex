defmodule Perspective.Projection do
  defmacro __using__(_) do
    quote do
      import Perspective.Projection
      use Perspective.ProjectionRegistry
      @projection_spec {nil, nil, nil}
    end
  end

  defmacro expose(path, reactor) do
    reactor_name = Macro.expand(reactor, __ENV__)
    channel_name = Module.concat(__CALLER__.module, Channel)

    quote do
      @projection_spec {unquote(path), unquote(channel_name), unquote(reactor_name)}

      defmodule Channel do
        use Phoenix.Channel
        import Perspective.ModuleRegistry
        register_module(Perspective.ProjectionChannel)

        def join(unquote(path), _message, socket) do
          {:ok, socket}
        end

        def handle_in("get", _message, socket) do
          message = unquote(reactor).get
          {:reply, {:ok, message}, socket}
        end

        def handle_in(unknown, payload, socket) do
          raise "You've attempted to use #{__MODULE__} with #{unknown}. Please fix"
        end

        def path, do: unquote(path)
      end

      def projection_spec, do: @projection_spec
    end
  end
end
