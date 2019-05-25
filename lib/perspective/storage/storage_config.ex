defmodule Perspective.StorageConfig do
  use GenServer
  use Perspective.Config, Perspective.LocalFileStorage

  defmodule State do
    @enforce_keys [:key]
    defstruct key: "unset"

    def new() do
      %__MODULE__{key: UUID.uuid4()}
    end
  end

  def path(file_name, subdirectory \\ "") do
    key = GenServer.call(__MODULE__, :key)
    Path.join([config(:path), key, subdirectory, file_name])
  end

  def set_new_key() do
    GenServer.call(__MODULE__, :set_new_key)
  end

  def handle_call(:key, _from, %State{key: key} = state) do
    {:reply, key, state}
  end

  def handle_call(:set_new_key, _from, _state) do
    state = State.new()
    {:reply, state.key, state}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    state = load_config()
    {:ok, state}
  end

  defp load_config do
    case Perspective.LoadLocalFile.load("storage-config.json") do
      {:error, %Perspective.LocalFileNotFound{}} -> create_and_load_new_config()
      data -> data
    end
    |> Perspective.Deserialize.deserialize()
  end

  defp create_and_load_new_config do
    save(State.new())
    Perspective.LoadLocalFile.load("storage-config.json")
  end

  defp save(state) do
    state
    |> Perspective.Serialize.to_json()
    |> Perspective.SaveLocalFile.save("storage-config.json")
  end
end
