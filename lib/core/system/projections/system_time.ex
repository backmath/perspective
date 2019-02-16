defmodule Core.System.SystemTime do
  use Perspective.Projection

  expose("system://time")

  initial_state do
    %{
      time: DateTime.utc_now()
    }
  end

  update(%Core.Services.SystemClock.Update{} = event, _state) do
    %{
      time: event.time
    }
  end
end
