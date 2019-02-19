defmodule Perspective.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Perspective.Notifications.Supervisor, []},
      {Perspective.DomainPoolSupervisor, []},
      {Perspective.EventChainSupervisor, []},
      {Core.Services.Supervisor, []},
      {Web.Endpoint, []}
    ]

    opts = [strategy: :one_for_one, name: Perspective.Application]
    Supervisor.start_link(children, opts)
  end
end
