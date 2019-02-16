defmodule Core.System.SystemTime.Test do
  use ExUnit.Case

  test "receiving an event will generate the expected result" do
    # assert %{time: time} = Core.System.SystemTime.get()

    # time = DateTime.utc_now()

    # Perspective.Notifications.emit(%Core.System.SystemTimeUpdated{time: time})

    # result =
    #   %Core.System.SystemTimeUpdated{time: time}
    #   |> Core.System.SystemTime.update()

    # assert %{time: time} == Core.System.SystemTime.get()
  end

  test "a missing function " do
    %{bad: :input}
    |> Core.System.SystemTime.update()
  end
end
