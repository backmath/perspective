defmodule Debouncer do
  use Agent

  def start_link(name: name) do
    Agent.start_link(fn -> :ready end, name: name)
  end

  def call(name, function) do
    case debouncer_state(name) do
      :ready -> start(name, function)
      :debouncing -> require_a_recall(name)
      :recall_when_done -> do_nothing()
    end

    :ok
  end

  defp start(name, function) do
    start_debouncing(name)
    run(name, function)
  end

  defp run(name, function) do
    Task.start(fn ->
      function.()

      if needs_to_recall(name) do
        run(name, function)
      end

      stop_debouncing(name)
    end)
  end

  defp debouncer_state(name) do
    Agent.get(name, fn state -> state end)
  end

  defp start_debouncing(name) do
    Agent.update(name, fn _ -> :debouncing end)
  end

  defp stop_debouncing(name) do
    Agent.update(name, fn _ -> :ready end)
  end

  defp require_a_recall(name) do
    Agent.update(name, fn _ -> :recall_when_done end)
  end

  defp needs_to_recall(name) do
    debouncer_state(name) == :recall_when_done
  end

  defp do_nothing(), do: nil
end
