defmodule Perspective.ActionRequest.RejectAnonymousUsers.Test.Example do
  use Perspective.ActionRequest
  use Perspective.ActionRequest.RejectAnonymousUsers
  @domain_event nil

  authorize_request(%{actor_id: "user/hello"}) do
    true
  end
end
