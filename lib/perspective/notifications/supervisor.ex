defmodule Perspective.Notifications.Supervisor do
  use Perspective.Supervisor

  children do
    [
      {Phoenix.PubSub.PG2, name: Perspective.Notifications.identifier()}
    ]
  end
end
