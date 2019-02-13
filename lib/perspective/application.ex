defmodule Perspective.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Perspective.DomainPoolSupervisor, []},
      {Perspective.EventChainSupervisor, []},
      {Perspective.Notifications.Supervisor, []}
    ]

    opts = [strategy: :one_for_one, name: Perspective.Application]
    Supervisor.start_link(children, opts)
  end
end
