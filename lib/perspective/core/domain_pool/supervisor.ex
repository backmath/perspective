defmodule Perspective.DomainPoolSupervisor do
  use Perspective.Supervisor

  children do
    [
      Perspective.Core.DomainPool
    ]
  end
end
