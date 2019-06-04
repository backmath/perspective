defmodule Perspective.Debouncer do
  use GenServer

  def start_link(name: name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    {:ok, Perspective.Debouncer.State.new()}
  end

  def register(name, function_key, function) do
    call_genserver(name, {:register, function_key, function})
  end

  def execute(name, function_key) do
    call_genserver(name, {:execute, name, function_key})
  end

  defp start(name, function_key) do
    run(name, function_key)
  end

  defp run(name, function_key) do
    Task.start(fn ->
      function = call_genserver(name, {:fetch_function, function_key})

      function.()

      if needs_to_recall(name, function_key) do
        run(name, function_key)

        stop_debouncing(name, function_key)
      end
    end)
  end

  defp stop_debouncing(name, function_key) do
    call_genserver(name, {:stop_debouncing, function_key})
  end

  defp condition(name, function_key) do
    call_genserver(name, {:condition, function_key})
  end

  defp needs_to_recall(name, function_key) do
    condition(name, function_key) == :recall_when_done
  end

  defp call_genserver(server, term, timeout \\ 5000) do
    try do
      GenServer.call(server, term, timeout)
    catch
      :exit, {:noproc, _} -> raise Perspective.Debouncer.MissingDebouncer, server
      error -> reraise(error, __STACKTRACE__)
    end
  end

  def handle_call({:register, function_key, function}, _from, state) do
    {:reply, :ok, Perspective.Debouncer.State.register(state, function_key, function)}
  end

  def handle_call({:stop_debouncing, function_key}, _from, state) do
    {:reply, :ok, Perspective.Debouncer.State.make_function_ready(state, function_key)}
  end

  def handle_call({:fetch_function, function_key}, _from, state) do
    {:reply, Perspective.Debouncer.State.fetch_function(state, function_key), state}
  end

  def handle_call({:condition, function_key}, _from, state) do
    {:reply, Perspective.Debouncer.State.condition(state, function_key), state}
  end

  def handle_call({:execute, name, function_key}, _from, state) do
    case Perspective.Debouncer.State.condition(state, function_key) do
      :ready ->
        start(name, function_key)
        {:reply, :ok, Perspective.Debouncer.State.start_debouncing(state, function_key)}

      :debouncing ->
        {:reply, :ok, Perspective.Debouncer.State.require_a_recall(state, function_key)}

      :recall_when_done ->
        {:reply, :ok, state}
    end
  end
end
