defmodule Core.UserAdded.Test do
  use ExUnit.Case

  test "apply the event" do
    event = %Core.UserAdded{
      data: %{
        user_id: "user:abc-123",
        username: "josh@backmath.com",
        password_hash: "b3Yk7..."
      }
    }

    _result = Core.UserAdded.Applier.apply_to(%Core.User{}, event)
  end
end
