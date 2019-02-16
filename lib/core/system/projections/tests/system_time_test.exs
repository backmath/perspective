defmodule Core.System.SystemTime.Test do
  use ExUnit.Case

  test "receiving an event will generate the expected result" do
    assert %{time: time} = Core.System.SystemTime.get()

    new_time = DateTime.utc_now()

    Perspective.Notifications.emit(%Core.Services.SystemClock.Update{time: new_time})

    assert %{time: new_time} == Core.System.SystemTime.get()
  end
end
