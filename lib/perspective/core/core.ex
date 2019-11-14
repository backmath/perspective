defmodule Perspective.Core do
  use Perspective.Application

  children do
    [
      Perspective.Core.Users,
      Perspective.Core.ToDos,
      Perspective.Core.AuthenticationVault.Supervisor
    ]
  end
end
