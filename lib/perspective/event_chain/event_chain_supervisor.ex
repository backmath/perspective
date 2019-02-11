defmodule Perspective.EventChainSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(_args) do
    children = [
      supervisor(Phoenix.PubSub.PG2, [Perspective.EventChainNotifications, []]),
      {Perspective.EventChain, :ok},
      {Perspective.EventChainStorageSupervisor, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
