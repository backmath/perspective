defmodule Perspective.Core.Authenticator.Test do
  use ExUnit.Case, async: true
  use Perspective.SetUniqueAppID

  setup(opts) do
    Perspective.ConfigureProcessAppId.configure(opts)
    Perspective.Core.start(opts)
    :ok
  end

  test "a request that skips authentication" do
    request = Perspective.Core.AddUser.new(%{})

    assert %Perspective.Core.AddUser{actor_id: "user/anonymous"} =
             Perspective.Core.Authenticator.authenticate_request(request, "")
  end

  test "a request authenticates correctly" do
    %Perspective.Core.UserAdded{data: %{user_id: "user/abc-123", username: "user-bob", password_hash: "[redacted]"}}
    |> Perspective.Notifications.emit()

    user = Perspective.Core.Users.find("user/abc-123")

    {:ok, token, _claims} = Perspective.Core.Guardian.encode_and_sign(user)

    request = Perspective.Core.AddToDo.new(%{})

    assert %Perspective.Core.AddToDo{actor_id: "user/abc-123"} =
             Perspective.Core.Authenticator.authenticate_request(request, token)
  end

  test "a request that fails authentication" do
    now = DateTime.utc_now() |> DateTime.to_unix()

    {:ok, token, _claims} =
      Perspective.Core.Guardian.encode_and_sign(%Perspective.Core.User{id: "user/abc-123"},
        exp: now - 1000
      )

    request = Perspective.Core.AddToDo.new(%{})

    assert {:error, %Perspective.Authentication.TokenError{error: :token_expired}} =
             Perspective.Core.Authenticator.authenticate_request(request, token)
  end
end
