defmodule Perspective.ActionRequest.RejectAnonymousUsers.Test.Example do
  use Perspective.ActionRequest
  use Perspective.ActionRequest.RejectAnonymousUsers
  @domain_event Perspective.ActionRequest.RejectAnonymousUsers.Test.ExampleEvent

  authorize_request(%{actor_id: "user/hello"}) do
    true
  end
end
