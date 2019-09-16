defmodule Perspective.Application.Supervisor do
  use Perspective.Supervisor

  children do
    [
      Perspective.EncryptionSupervisor,
      Perspective.Notifications.Supervisor,
      Perspective.DomainPoolSupervisor,
      Perspective.EventChainSupervisor,
      Perspective.RequestRegistry,
      Perspective.AuthenticationVault.Supervisor
    ]
  end
end
