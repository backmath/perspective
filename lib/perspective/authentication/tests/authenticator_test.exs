defmodule Perspective.Authenticator.Test do
  use ExUnit.Case

  test "the DefaultAuthenticator attaches a user/anonymous actor_id" do
    request = Perspective.Authentication.DefaultAuthenticator.authenticate(%{}, nil)

    assert %{actor_id: "user/anonymous"} == request
  end
end
