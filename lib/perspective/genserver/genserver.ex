defmodule Perspective.GenServer do
  defmacro __using__(_) do
    quote do
      use GenServer
      use Perspective.IdentifierMacro
      import Perspective.AppID
      import Perspective.GenServer

      def init(opts) do
        Perspective.GenServer.ProcessIdentifiers.store(module(), opts)
        {:ok, initial_state()}
      end

      def start_link(options) when is_list(options) or is_map(options) do
        name = module().name(options)

        GenServer.start_link(module(), options, name: name)
      end

      def start_link() do
        start_link([])
      end

      def start_link(_) do
        start_link([])
      end

      def initial_state do
        nil
      end

      def handle_call(:state, _from, state) do
        {:reply, state, state}
      end

      def handle_call(:app_id, _from, state) do
        {:reply, Perspective.AppID.app_id(), state}
      end

      def handle_call(:name, _from, state) do
        {:reply, Process.get(:name), state}
      end

      def call(id, data, timeout \\ 5000) do
        name([id: id])
        |> GenServer.call(data, timeout)
      end

      def cast(id, data) do
        name([id: id])
        |> GenServer.cast(data)
      end

      def call(data) do
        call(nil, data)
      end

      def cast(data) do
        cast(nil, data)
      end

      defoverridable(call: 3, initial_state: 0)

      defp module do
        unquote(__CALLER__.module)
      end
    end
  end

  defmacro initial_state(do: block) do
    quote do
      def initial_state, do: unquote(block)
    end
  end
end
