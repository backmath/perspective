defmodule Perspective.DomainPoolSupervisor do
  use Perspective.Supervisor

  children do
    [
      Perspective.DomainPool
    ]
  end
end
