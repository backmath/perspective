defmodule Perspective.Application.Supervisor do
  use Perspective.Supervisor

  children do
    [
      Perspective.EncryptionSupervisor,
      Perspective.Notifications.Supervisor,
      Perspective.EventChainSupervisor,
      Perspective.RequestRegistry
    ]
  end
end
