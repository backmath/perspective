defmodule Core do
  use Perspective.Application

  children do
    [
      Core.ToDo.Reactor.Supervisor,
      Core.User.Reactor.Supervisor,
      Core.Services.Supervisor
      # {Web.Endpoint, []}
    ]
  end
end
