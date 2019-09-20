defmodule Perspective.Core do
  use Perspective.Application

  children do
    [
      Perspective.DomainPoolSupervisor,
      Perspective.Core.ToDo.Reactor.Supervisor,
      Perspective.Core.AuthenticationVault.Supervisor
    ]
  end
end
