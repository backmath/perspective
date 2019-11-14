defmodule Perspective.User.Reactor.Test do
  use ExUnit.Case, async: true
  use Perspective.SetUniqueAppID

  setup do
    Perspective.Core.start()
    :ok
  end

  setup(context) do
    Perspective.Core.Users.start_link(context)
    :ok
  end

  test "Perspective.Core.User.Reactor reacts to Perspective.Core.UserAdded and creates a Perspective.Core.User node" do
    %Perspective.Core.UserAdded{data: %{user_id: "user/abc-123", username: "user-bob", password_hash: "[redacted]"}}
    |> Perspective.Notifications.emit()

    result = Perspective.Core.Users.find("user/abc-123")

    assert %Perspective.Core.User{
             id: "user/abc-123",
             username: "user-bob"
           } == result
  end
end
