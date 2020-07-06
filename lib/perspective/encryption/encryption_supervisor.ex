defmodule Perspective.EncryptionSupervisor do
  use Perspective.Supervisor

  children do
    [
      Perspective.EncryptionConfiguration
    ]
  end
end
