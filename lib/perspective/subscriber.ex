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
end
