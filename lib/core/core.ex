defmodule Core do
  use Perspective.Application

  children do
    [
      Core.ToDo.Reactor.Supervisor,
      Core.User.Reactor.Supervisor
      # {Web.Endpoint, []}
    ]
  end
end
