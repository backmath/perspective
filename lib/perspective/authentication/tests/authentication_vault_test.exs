defmodule Perspective.AuthenticationVault.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "the authentication vault stores state correctly" do
    assert {:error, %Perspective.Authentication.UsernameNotFound{username: "josh@backmath.com"}} ==
             Perspective.AuthenticationVault.credentials_for("josh@backmath.com")

    Perspective.AuthenticationVault.send(%Core.UserAdded{
      data: %{user_id: "user:abc-123", username: "josh@backmath.com", password_hash: "[redacted]"}
    })

    assert {:ok, %{password_hash: "[redacted]", user_id: "user:abc-123", username: "josh@backmath.com"}} ==
             Perspective.AuthenticationVault.credentials_for("josh@backmath.com")
  end
end
