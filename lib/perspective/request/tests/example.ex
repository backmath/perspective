defmodule Perspective.ActionRequest.RejectAnonymousUsers.Test.Example do
  use Perspective.ActionRequest
  use Perspective.ActionRequest.RejectAnonymousUsers

  domain_event(Perspective.ActionRequest.RejectAnonymousUsers.Test.ExampleEvent, "1.0")

  authorize(%{actor_id: "user/hello"}) do
    true
  end
end
