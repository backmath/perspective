defmodule Perspective.Subscriber do
  defmacro __using__(_) do
    calling_module = __CALLER__.module

    quote do
      use GenServer
      import Perspective.Subscriber

      def init({notifications_module, topic}) do
        :ok = Phoenix.PubSub.subscribe(notifications_module, topic)
        initial_state = %{}
        {:ok, initial_state}
      end

      def start_link(data) do
        GenServer.start_link(unquote(calling_module), data, name: unquote(calling_module))
      end
    end
  end

  defmacro subscribe(notifications_module, topic, do: block) do
    # Perspective.Subscriber.start_link({notifications_module, topic})
    quote do
      def handle_info(unquote(topic), state), do: block
    end
  end

  # defmacro handle(message, state, do: block) do
  #   quote do
  #     def handle(unquote(message), unquote(state)), do: unquote(block)
  #     def handle_info(unquote(message), unquote(state)), do: unquote(block)
  #   end
  # end
end
