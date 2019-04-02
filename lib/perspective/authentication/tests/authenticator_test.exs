defmodule Perspective.Authenticator.Test do
  use ExUnit.Case

  test "a request that skips authentication" do
    request = Core.AddUser.new(%{})

    assert {:ok, %Core.AddUser{actor_id: "user:anonymous"}} =
             Perspective.Authenticator.authenticate_request(request, "")
  end

  test "a request authenticates correctly" do
    user = %Core.User{id: "user:abc-123"}
    Perspective.DomainPool.put(user)
    {:ok, token, _claims} = Perspective.Guardian.encode_and_sign(user)

    request = Core.AddToDo.new(%{})

    assert {:ok, %Core.AddToDo{actor_id: "user:abc-123"}} =
             Perspective.Authenticator.authenticate_request(request, token)
  end

  test "a request that fails authentication" do
    now = DateTime.utc_now() |> DateTime.to_unix()

    {:ok, token, _claims} =
      Perspective.Guardian.encode_and_sign(%Core.User{id: "user:abc-123"},
        exp: now - 1000
      )

    request = Core.AddToDo.new(%{})

    assert {:error, :token_expired} = Perspective.Authenticator.authenticate_request(request, token)
  end
end
