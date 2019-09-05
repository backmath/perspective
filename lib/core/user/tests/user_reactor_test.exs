defmodule Perspective.User.Reactor.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  setup(context) do
    Core.User.Reactor.Supervisor.start_link(context)
    :ok
  end

  test "Core.User.Reactor reacts to Core.UserAdded and creates a Core.User node" do
    %Core.UserAdded{data: %{user_id: "user/abc-123", username: "user-bob", password_hash: "[redacted]"}}
    |> Core.User.Reactor.send()

    result = Perspective.DomainPool.get!("user/abc-123")

    assert %Core.User{
             id: "user/abc-123",
             username: "user-bob",
             password_hash: "[redacted]"
           } == result
  end
end
