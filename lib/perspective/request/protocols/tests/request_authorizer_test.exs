defmodule Perspective.ActionRequest.RequestAuthorizer.Test do
  use ExUnit.Case, async: true

  test "authorize returns an empty list as a fallback" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
      domain_event(Perspective.ActionRequest.RequestAuthorizer.Test.DefaultExampleEvent, "1.0")
    end

    assert [] == Perspective.ActionRequest.RequestAuthorizer.authorize(DefaultExample.new())
  end
end
