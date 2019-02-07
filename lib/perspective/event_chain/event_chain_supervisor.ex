defmodule Perspective.EventChainSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(_args) do
    children = [
      {Perspective.EventChain, :ok}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
