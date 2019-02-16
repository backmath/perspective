defmodule Perspective.Projection do
  defmacro __using__(_) do
    quote do
      use Perspective.Reactor
      import Perspective.Projection
    end
  end

  defmacro expose(path) do
    quote do
      defmodule Channel do
        use Phoenix.Channel

        def join(unquote(path), _message, socket) do
          {:ok, socket}
        end

        def handle_in("get", _message, socket) do
          data = %{important_things_completed: 0}

          push(socket, "get", data)

          {:reply, {:ok, data}, socket}
        end
      end
    end
  end
end
