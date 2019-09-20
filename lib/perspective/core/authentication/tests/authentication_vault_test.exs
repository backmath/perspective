defmodule Perspective.Core.AuthenticationVault.Test do
  use ExUnit.Case, async: true
  use Perspective.SetUniqueAppID

  setup do
    Perspective.Core.start()
    :ok
  end

  test "the authentication vault stores state correctly" do
    assert {:error, %Perspective.Authentication.UsernameNotFound{username: "josh@backmath.com"}} ==
             Perspective.Core.AuthenticationVault.credentials_for("josh@backmath.com")

    Perspective.Core.AuthenticationVault.send(%Perspective.Core.UserAdded{
      data: %{user_id: "user:abc-123", username: "josh@backmath.com", password_hash: "[redacted]"}
    })

    assert {:ok, %{password_hash: "[redacted]", user_id: "user:abc-123", username: "josh@backmath.com"}} ==
             Perspective.Core.AuthenticationVault.credentials_for("josh@backmath.com")
  end
end
