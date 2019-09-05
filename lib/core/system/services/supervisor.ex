defmodule Core.Services.Supervisor do
  use Perspective.Supervisor

  children do
    [
      Core.Services.SystemClock.Supervisor
    ]
  end
end
