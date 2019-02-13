defmodule Perspective.NotificationsSubscriber do
  defmacro __using__(name: name) do
    quote do
      use GenServer

      def start_link(node_id) do
        GenServer.start_link(__MODULE__, node_id)
      end

      def init(node_id) do
        :ok = Phoenix.PubSub.subscribe(unquote(name), node_id)
        initial_state = %{}
        {:ok, initial_state}
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
