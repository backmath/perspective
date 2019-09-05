defmodule Perspective.EventChain.PageBuffer do
  use Perspective.GenServer
  alias Perspective.EventChain.PageBuffer.State

  initial_state do
    State.new()
  end

  def add(event) do
    cast({:add, event})
  end

  def take_out(amount) do
    call({:take_out, amount})
  end

  def clear() do
    call(:clear)
  end

  def has_events?() do
    call(:has_events?)
  end

  def handle_cast({:add, event}, state) do
    {:noreply, State.add(state, event)}
  end

  def handle_call({:take_out, amount}, _from, state) do
    {state, taken} = State.take_out(state, amount)
    {:reply, taken, state}
  end

  def handle_call(:has_events?, _from, state) do
    {:reply, State.has_events?(state), state}
  end

  def handle_call(:clear, _from, _) do
    {:reply, :ok, State.new()}
  end
end
