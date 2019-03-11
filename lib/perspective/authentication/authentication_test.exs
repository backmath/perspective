defmodule Perspective.Authentication.Test do
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
             Perspective.Authentication.authenticate(request, token)
  end

  test "a request authenticates correctly" do
    {:ok, token, _claims} = Perspective.Guardian.encode_and_sign(%Core.User{id: "user:abc-123"})

    request =
      Perspective.RequestGenerator.from(%{
        action: "Core.AddToDo",
        data: %{}
      })

    assert {:ok, %Perspective.ActionRequest{actor_id: "user:abc-123"}} =
             Perspective.Authentication.authenticate(request, token)
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

    assert {:error, :token_expired} = Perspective.Authentication.authenticate(request, token)
  end

  test "authentication test" do
    result = Perspective.Authentication.hash_password("abc-123")
    assert result =~ ~r/^\$argon2id/
  end

  test "generate_authentication_token" do
    # @todo add test
    # result = Perspective.Authentication.generate_authentication_token("josh@backmath.com")
  end
end
