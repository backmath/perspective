defmodule Perspective.Core do
  use Perspective.Application

  children do
    [
      Perspective.Core.UserPool,
      Perspective.Core.ToDoPool,
      Perspective.Core.ToDo.Reactor.Supervisor,
      Perspective.Core.AuthenticationVault.Supervisor
    ]
  end
end
