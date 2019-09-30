defmodule Perspective.ActionRequest.RequestAuthorizer.Test do
  use ExUnit.Case, async: true

  test "by default, all actions are unauthorized" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
      domain_event(Perspective.ActionRequest.RequestAuthorizer.Test.DefaultExampleEvent, "1.0")
    end

    assert {:error, %Perspective.Unauthorized{}} =
             Perspective.ActionRequest.RequestAuthorizer.authorize(DefaultExample.new())
  end

  test "authorization with a specific actor_id" do
    defmodule Example do
      use Perspective.ActionRequest
      domain_event(Perspective.ActionRequest.RequestAuthorizer.Test.ExampleEvent, "1.0")

      authorize(%{actor_id: "user/josh"}) do
        true
      end
    end

    assert true == Perspective.ActionRequest.RequestAuthorizer.authorize(Example.new("user/josh"))

    request = Example.new("user/nope")

    assert {:error,
            %Perspective.Unauthorized{
              errors: [],
              request: request
            }} == Perspective.ActionRequest.RequestAuthorizer.authorize(request)
  end
end
