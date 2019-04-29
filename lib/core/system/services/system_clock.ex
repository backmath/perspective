defmodule Core.Services.SystemClock do
  use Perspective.Reactor

  defmodule NewTime do
    defstruct time: DateTime.utc_now()
  end

  initial_state do
    schedule_next_update()

    %{
      time: DateTime.utc_now()
    }
  end

  update(%NewTime{time: time} = _event, _state) do
    schedule_next_update()

    %{
      time: time
    }
  end

  defp schedule_next_update do
    time = DateTime.utc_now()
    Process.send_after(self(), %NewTime{time: time}, time_until_next_even_five(time))
  end

  defp time_until_next_even_five(time) do
    seconds = 4 - rem(time.second, 5)
    microseconds = 1_000_000 - elem(time.microsecond, 0)
    milliseconds_to_wait = seconds * 1000 + microseconds / 1000
    round(milliseconds_to_wait)
  end
end
