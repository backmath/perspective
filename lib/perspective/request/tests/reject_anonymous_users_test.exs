defmodule Perspective.ActionRequest.RejectAnonymousUsers.Test do
  use ExUnit.Case, async: true
  alias Perspective.ActionRequest.RejectAnonymousUsers.Test.Example

  test "using the module will reject anonymous requests" do
    assert {:error, %Perspective.AnonymousUserRejected{}} == Example.authorize_request(%Example{actor_id: nil})
    assert {:error, %Perspective.AnonymousUserRejected{}} == Example.authorize_request(%Example{actor_id: ""})

    assert {:error, %Perspective.AnonymousUserRejected{}} ==
             Example.authorize_request(%Example{actor_id: "user/anonymous"})
  end

  test "specific authorizations still work" do
    assert true == Example.authorize_request(%Example{actor_id: "user/hello"})
  end

  test "unspecfied authorizations fail by default" do
    assert {:error, %Perspective.Unauthorized{}} == Example.authorize_request(%Example{actor_id: "user/missing"})
    assert true = Perspective.ActionRequest.RequestAuthorizer.authorize_request(%Example{actor_id: "user/hello"})
  end
end
