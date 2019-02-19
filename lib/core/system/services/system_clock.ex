defmodule Core.Services.SystemClock do
  use Perspective.Reactor

  defmodule Update do
    defstruct time: DateTime.utc_now()
  end

  initial_state do
    schedule_next_update()

    %{
      time: DateTime.utc_now()
    }
  end

  update(%Update{time: time} = _event, _state) do
    schedule_next_update()

    %{
      time: time
    }
  end

  defp schedule_next_update do
    time = DateTime.utc_now()
    Process.send_after(self(), :tick, time_until_next_even_five(time))
  end

  defp time_until_next_even_five(time) do
    seconds = 4 - rem(time.second, 5)
    microseconds = 1_000_000 - elem(time.microsecond, 0)
    milliseconds_to_wait = seconds * 1000 + microseconds / 1000
    round(milliseconds_to_wait)
  end

  def handle_info(:tick, state) do
    time = DateTime.utc_now()
    Perspective.Notifications.emit(%Update{time: time})
    {:noreply, state}
  end
end
