defmodule Perspective.AuthenticationVault.Test do
  use ExUnit.Case

  test "the authentication vault stores state correctly" do
    vault = Perspective.AuthenticationVault.start()

    assert {:error, :username_not_found} == Perspective.AuthenticationVault.password_hash_for("josh@backmath.com")

    Perspective.Notifications.emit(%Perspective.DomainEvent{
      event_type: "Core.UserAdded",
      event: %{username: "josh@backmath.com", password_hash: "[redacted]"}
    })

    assert {:ok, "[redacted]"} == Perspective.AuthenticationVault.password_hash_for("josh@backmath.com")
  end
end
