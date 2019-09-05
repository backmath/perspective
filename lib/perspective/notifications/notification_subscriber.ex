defmodule Perspective.NotificationsSubscriber do
  defmacro __using__(name: name) do
    quote do
      use Perspective.GenServer

      initial_state do
        Phoenix.PubSub.subscribe(unquote(name), node_id)
        %{}
      end
    end
  end

  defmacro handle(message, do: block) do
    quote do
      def handle(unquote(message)), do: unquote(block)
      def handle_info(unquote(message), state), do: unquote(block)
    end
  end
end
