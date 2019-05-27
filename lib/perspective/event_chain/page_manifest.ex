defmodule Perspective.EventChain.PageManifest do
  use GenServer
  use Perspective.Config, Perspective.LocalFileStorage

  defmodule State do
    defstruct pages: []

    def new() do
      page_name = new_page_name()

      %State{
        pages: [page_name]
      }
    end

    def current_page(%State{pages: pages}) do
      List.last(pages)
    end

    def add_page(%State{pages: pages} = state) do
      next_page_name =
        State.current_page(state)
        |> next_page_number()
        |> new_page_name()

      %State{
        pages: pages ++ [next_page_name]
      }
    end

    defp next_page_number(name) do
      ~r/event-chain\.(.*)\.json/
      |> Regex.run(name)
      |> Enum.at(1)
      |> String.to_integer()
      |> Kernel.+(1)
    end

    defp new_page_name(count \\ 0) do
      number = String.pad_leading("#{count}", 7, "0")
      "event-chain.#{number}.json"
    end
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    state = load_manifest()
    {:ok, state}
  end

  def current_page do
    GenServer.call(__MODULE__, :current_page)
  end

  def add_page do
    GenServer.call(__MODULE__, :add_page)
  end

  def pages do
    GenServer.call(__MODULE__, :pages)
  end

  def handle_call(:current_page, _, state) do
    {:reply, State.current_page(state), state}
  end

  def handle_call(:add_page, _, state) do
    new_state = State.add_page(state)
    save(new_state)
    {:reply, :ok, new_state}
  end

  def handle_call(:pages, _, %{pages: pages} = state) do
    {:reply, pages, state}
  end

  defp save(state) do
    state
    |> Perspective.Serialize.to_json()
    |> Perspective.SaveLocalFile.save(file_path())
  end

  defp load_manifest do
    case Perspective.LoadLocalFile.load(file_path()) do
      {:error, %Perspective.LocalFileNotFound{}} -> create_manifest()
      data -> data
    end
    |> Perspective.Deserialize.deserialize()
  end

  defp file_path do
    Perspective.StorageConfig.path("event-chain-manifest.json")
  end

  defp create_manifest do
    save(State.new())
    Perspective.LoadLocalFile.load(file_path())
  end
end
