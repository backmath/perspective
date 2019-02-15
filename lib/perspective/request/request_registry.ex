defmodule Perspective.RequestRegistry do
  defmodule RequestCompleted do
    defstruct [:request]
  end

  def register() do
    Perspective.Notifications.subscribe(%Perspective.Request.RequestCompleted{})
    Perspective.Notifications.subscribe(%Perspective.Request.RequestRejected{})
  end
end
