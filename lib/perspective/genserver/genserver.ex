defmodule Perspective.GenServer do
  defmacro __using__(_) do
    quote do
      use GenServer
      import Perspective.GenServer

      def init(opts) do
        Perspective.ServerReferences.store_process_references(module(), opts)
        {:ok, initial_state()}
      end

      def start_link(options) when is_list(options) or is_map(options) do
        GenServer.start_link(module(), options, name: get_name_from_opts(options))
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
        {:reply, Process.get(:app_id), state}
      end

      def handle_call(:name, _from, state) do
        {:reply, Process.get(:name), state}
      end

      def call(data, timeout \\ 5000) do
        GenServer.call(get_name(module()), data, timeout)
      end

      def cast(data) do
        GenServer.cast(get_name(module()), data)
      end

      defoverridable(initial_state: 0)

      defp module do
        unquote(__CALLER__.module)
      end

      defp get_name_from_opts(opts) when is_list(opts) do
        Keyword.get(opts, :name, get_name(module()))
      end

      defp get_name_from_opts(opts) when is_map(opts) do
        Map.get(opts, :name, get_name(module()))
      end

      defp get_name(module) when is_atom(module) do
        app_id = Perspective.AppID.fetch_and_set()

        if app_id == nil do
          raise ArgumentError,
                "\nYou called #{__MODULE__}.call/cast without setting the parent processes' app_id\n\nCall Process.put(:app_id, *process-id*)"
        end

        Perspective.ServerName.name(module, app_id)
      end
    end
  end

  defmacro initial_state(do: block) do
    quote do
      def initial_state, do: unquote(block)
    end
  end
end
