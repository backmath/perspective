defmodule Perspective.EventChainSupervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_args) do
    children = [
      {Debouncer, [name: PageWriterDebouncer]},
      {Perspective.EventChain.PageManifest, []},
      {Perspective.EventChain.CurrentPage, []},
      {Perspective.EventChain.PageBuffer, []},
      {Perspective.EventChain.PageWriter, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
