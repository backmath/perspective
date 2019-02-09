defmodule Perspective.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      {Perspective.DomainPoolSupervisor, []},
      {Perspective.EventChainSupervisor, []},
      {Perspective.EventChainStorageSupervisor, []}
    ]

    opts = [strategy: :one_for_one, name: Perspective.Application]
    Supervisor.start_link(children, opts)
  end
end
