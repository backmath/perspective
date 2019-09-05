defmodule Perspective.EventChain.CurrentPage do
  use Perspective.GenServer
  alias Perspective.EventChain.CurrentPage.State

  initial_state do
    events = Perspective.EventChain.LoadCurrentPage.run()
    %State{events: events}
  end

  def add(events) do
    call({:add, events})
  end

  def event_count_remaining do
    call(:event_count_remaining)
  end

  def start_new_page do
    call(:start_new_page)
  end

  def is_full? do
    call(:is_full?)
  end

  def events do
    call(:events)
  end

  def get do
    call(:get)
  end

  def handle_call({:add, events}, _from, state) do
    new_state = State.add(state, events)
    {:reply, new_state, new_state}
  end

  def handle_call(:event_count_remaining, _from, state) do
    {:reply, State.event_count_remaining(state), state}
  end

  def handle_call(:start_new_page, _from, _state) do
    {:reply, State.new(), State.new()}
  end

  def handle_call(:is_full?, _from, state) do
    {:reply, State.is_full?(state), state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:events, _from, %{events: events} = state) do
    {:reply, events, state}
  end
end
