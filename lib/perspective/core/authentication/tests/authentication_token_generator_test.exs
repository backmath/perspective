defmodule Perspective.Core.AuthenticationTokenGenerator.Test do
  use ExUnit.Case, async: true
  use Perspective.SetUniqueAppID

  setup(opts) do
    Perspective.ConfigureProcessAppId.configure(opts)
    Perspective.Core.start(opts)
    :ok
  end

  test "authentication test" do
    result = Perspective.Core.AuthenticationTokenGenerator.hash_password("abc-123")
    assert result =~ ~r/^\$argon2id/
  end

  test "generate_authentication_token" do
    %Perspective.Core.UserAdded{
      data: %{
        user_id: "user:abc-123",
        username: "josh@backmath.com",
        password_hash: Argon2.hash_pwd_salt("password-bh5r")
      }
    }
    |> Perspective.Core.AuthenticationVault.send()

    result =
      Perspective.Core.AuthenticationTokenGenerator.generate_authentication_token(
        "josh@backmath.com",
        "password-bh5r"
      )

    assert result =~ ~r/^eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.*/
  end

  test "generate_authentication_token errors for missing users" do
    result =
      Perspective.Core.AuthenticationTokenGenerator.generate_authentication_token(
        "missing@backmath.com",
        "doesn't matter"
      )

    assert {:error, %Perspective.Authentication.UsernameNotFound{username: "missing@backmath.com"}} = result
  end

  test "generate_authentication_token errors for a failed password attempt" do
    %Perspective.Core.UserAdded{
      data: %{
        user_id: "user:abc-123",
        username: "josh@backmath.com",
        password_hash: Argon2.hash_pwd_salt("password-bh5r")
      }
    }
    |> Perspective.Core.AuthenticationVault.send()

    result =
      Perspective.Core.AuthenticationTokenGenerator.generate_authentication_token(
        "josh@backmath.com",
        "wrong-password"
      )

    assert {:error, %Perspective.Authentication.PasswordChallengeFailed{username: "josh@backmath.com"}} = result
  end
end
