defmodule Core.User.Test do
  use ExUnit.Case

  test "apply_event: AddUser " do
    user = %Core.User{}

    event = %Core.UserAdded{
      user_id: "user:abc-123",
      username: "josh@backmath.com"
    }

    expected = %Core.User{
      id: "user:abc-123",
      username: "josh@backmath.com"
    }

    assert {:ok, result} = Core.User.apply_event(user, event)

    assert result == expected
  end
end
