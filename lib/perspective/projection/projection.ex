defmodule Perspective.Projection do
  defmacro __using__(_) do
    quote do
      import Perspective.Projection
    end
  end

  defmacro expose(path, reactor) do
    quote do
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

        def handle_in("update", message, socket) do
          broadcast!(socket, "update", message)
          {:noreply, socket}
        end

        def handle_in(unknown, payload, socket) do
          raise "You've attempted to use #{__MODULE__} with #{unknown}. Please fix"
        end

        def path, do: unquote(path)
      end
    end
  end
end
