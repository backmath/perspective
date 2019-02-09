defmodule Perspective.DomainPoolSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(_args) do
    children = [
      {Perspective.DomainPool, :ok},
      supervisor(Phoenix.PubSub.PG2, [Perspective.DomainPoolNotifications, []])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
