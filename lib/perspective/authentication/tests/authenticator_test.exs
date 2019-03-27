defmodule Perspective.Authenticator.Test do
  use ExUnit.Case

  test "a request that skips authentication" do
    token = ""

    request =
      Perspective.RequestGenerator.from(%{
        action: "Core.AddUser",
        data: %{
          name: "some-username"
        }
      })

    assert {:ok, %Perspective.ActionRequest{actor_id: "user:anonymous"}} =
             Perspective.Authenticator.authenticate_request(request, token)
  end

  test "a request authenticates correctly" do
    user = %Core.User{id: "user:abc-123"}
    Perspective.DomainPool.put(user)
    {:ok, token, _claims} = Perspective.Guardian.encode_and_sign(user)

    request =
      Perspective.RequestGenerator.from(%{
        action: "Core.AddToDo",
        data: %{}
      })

    assert {:ok, %Perspective.ActionRequest{actor_id: "user:abc-123"}} =
             Perspective.Authenticator.authenticate_request(request, token)
  end

  test "a request that fails authentication" do
    now = DateTime.utc_now() |> DateTime.to_unix()

    {:ok, token, _claims} =
      Perspective.Guardian.encode_and_sign(%Core.User{id: "user:abc-123"},
        exp: now - 1000
      )

    request =
      Perspective.RequestGenerator.from(%{
        action: "Core.AddToDo",
        data: %{}
      })

    assert {:error, :token_expired} = Perspective.Authenticator.authenticate_request(request, token)
  end
end
