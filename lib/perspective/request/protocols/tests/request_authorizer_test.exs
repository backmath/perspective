defmodule Perspective.ActionRequest.RequestAuthorizer.Test do
  use ExUnit.Case, async: true

  test "authorize returns an empty list as a fallback" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
      @domain_event DefaultExampleEvent
    end

    assert [] == Perspective.ActionRequest.RequestAuthorizer.authorize_request(DefaultExample.new())
  end
end
