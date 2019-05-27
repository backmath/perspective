defmodule Perspective.EventChain.PageBuffer do
  use GenServer

  defmodule State do
    defstruct [:events]

    def new(), do: %State{events: []}
    def add(%State{events: events}, event), do: %State{events: events ++ [event]}

    def has_events?(%State{events: []}), do: false
    def has_events?(%State{events: _events}), do: true

    def take_out(%State{events: events}, amount) do
      {taken, left} = Enum.split(events, amount)
      {%State{events: left}, taken}
    end
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, State.new()}
  end

  def add(event) do
    GenServer.cast(__MODULE__, {:add, event})
  end

  def take_out(amount) do
    GenServer.call(__MODULE__, {:take_out, amount})
  end

  def clear() do
    GenServer.call(__MODULE__, :clear)
  end

  def has_events?() do
    GenServer.call(__MODULE__, :has_events?)
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
