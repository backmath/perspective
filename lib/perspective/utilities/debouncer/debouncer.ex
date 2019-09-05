defmodule Perspective.Debouncer do
  defmacro __using__(_) do
    quote do
      import Perspective.Debouncer
      use Perspective.GenServer

      initial_state do
        Perspective.Debouncer.State.new()
      end

      def execute() do
        call(:execute)
      end

      defp start() do
        run()
      end

      defp run() do
        app_id = Process.get(:app_id)

        Task.start(fn ->
          Process.put(:app_id, app_id)

          run_execute()

          if needs_to_recall() do
            run()
            stop_debouncing()
          else
            stop_debouncing()
          end
        end)
      end

      defp stop_debouncing() do
        call(:stop_debouncing)
      end

      def condition() do
        call(:condition)
      end

      defp needs_to_recall() do
        condition() == :recall_when_done
      end

      def handle_call(:stop_debouncing, _from, state) do
        {:reply, :ok, Perspective.Debouncer.State.new()}
      end

      def handle_call(:condition, _from, state) do
        {:reply, Perspective.Debouncer.State.condition(state), state}
      end

      def handle_call(:execute, _from, state) do
        case Perspective.Debouncer.State.condition(state) do
          :ready ->
            start()
            {:reply, :ok, Perspective.Debouncer.State.start_debouncing(state)}

          :debouncing ->
            {:reply, :ok, Perspective.Debouncer.State.require_a_recall(state)}

          :recall_when_done ->
            {:reply, :ok, Perspective.Debouncer.State.require_a_recall(state)}
        end
      end
    end
  end

  defmacro execute(do: block) do
    quote do
      def run_execute(), do: unquote(block)
    end
  end
end
