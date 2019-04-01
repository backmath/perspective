defmodule Perspective.AuthenticationVault.Test do
  use ExUnit.Case

  test "the authentication vault stores state correctly" do
    Perspective.EventChain.load([])
    Perspective.AuthenticationVault.reset()

    assert {:error, %Perspective.Authentication.UsernameNotFound{username: "josh@backmath.com"}} ==
             Perspective.AuthenticationVault.credentials_for("josh@backmath.com")

    Perspective.Notifications.emit(%Core.UserAdded{
      data: %{user_id: "user:abc-123", username: "josh@backmath.com", password_hash: "[redacted]"}
    })

    assert {:ok, {"user:abc-123", "josh@backmath.com", "[redacted]"}} ==
             Perspective.AuthenticationVault.credentials_for("josh@backmath.com")
  end

  test "the authentication vault reboots correctly" do
    Perspective.AuthenticationVault.reset()

    Perspective.EventChain.apply_event(%Core.UserAdded{
      data: %{user_id: "user:abc-123", username: "josh@backmath.com", password_hash: "[redacted]"}
    })

    Perspective.AuthenticationVault.reset()

    :timer.sleep(100)

    assert {:ok, {"user:abc-123", "josh@backmath.com", "[redacted]"}} =
             Perspective.AuthenticationVault.credentials_for("josh@backmath.com")
  end
end
