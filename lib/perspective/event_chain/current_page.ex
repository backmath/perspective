defmodule Perspective.EventChain.CurrentPage do
  use GenServer

  defmodule State do
    use Perspective.Config

    defstruct [:events]

    def new, do: %State{events: []}

    def add(%{events: events}, new_events) when is_list(new_events), do: %State{events: events ++ new_events}
    def add(state, new_event), do: add(state, [new_event])

    def event_count_remaining(state) do
      count = config(:max_events_per_page) - length(state.events)

      if count > 0 do
        count
      else
        0
      end
    end

    def is_full?(state), do: length(state.events) >= config(:max_events_per_page)
  end

  def add(events) do
    GenServer.call(__MODULE__, {:add, events})
  end

  def event_count_remaining do
    GenServer.call(__MODULE__, :event_count_remaining)
  end

  def start_new_page do
    GenServer.call(__MODULE__, :start_new_page)
  end

  def is_full? do
    GenServer.call(__MODULE__, :is_full?)
  end

  def events do
    GenServer.call(__MODULE__, :events)
  end

  def get do
    GenServer.call(__MODULE__, :get)
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

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    events = load_current_page()
    {:ok, %State{events: events}}
  end

  defp load_current_page() do
    Perspective.EventChain.PageManifest.current_page()
    |> Perspective.StorageConfig.path()
    |> Perspective.LoadLocalFile.load()
    |> case do
      {:error, %Perspective.LocalFileNotFound{}} -> save_and_load_new_page()
      data -> data
    end
    |> Perspective.Deserialize.deserialize()
  end

  defp save_and_load_new_page do
    path =
      Perspective.EventChain.PageManifest.current_page()
      |> Perspective.StorageConfig.path()

    Perspective.SaveLocalFile.save("[]", path)

    Perspective.LoadLocalFile.load(path)
  end
end
