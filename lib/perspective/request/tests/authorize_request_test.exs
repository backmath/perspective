defmodule Perspective.Request.AuthorizeRequest.Test do
  use ExUnit.Case, async: true

  defmodule Example do
    use Perspective.ActionRequest
    domain_event(ExampleEvent, "1.0")
  end

  test "by default, the Example is unauthorized" do
    request = Example.new("user/doesn't-matter")
    assert false == Perspective.ActionRequest.RequestAuthorizer.authorize(request)
  end

  defmodule AnotherExample do
    use Perspective.ActionRequest
    domain_event(AnotherExampleEvent, "1.0")

    authorize(%{actor_id: "user/ok"}) do
      true
    end

    authorize(%{actor_id: "user/not-ok"}) do
      false
    end

    authorize(%{actor_id: actor_id}) do
      case actor_id do
        "user/case-ok" -> true
        _ -> false
      end
    end
  end

  test "progressive allowances" do
    assert true == Perspective.ActionRequest.RequestAuthorizer.authorize(AnotherExample.new("user/ok"))
    assert false == Perspective.ActionRequest.RequestAuthorizer.authorize(AnotherExample.new("user/not-ok"))
    assert true == Perspective.ActionRequest.RequestAuthorizer.authorize(AnotherExample.new("user/case-ok"))
    assert false == Perspective.ActionRequest.RequestAuthorizer.authorize(AnotherExample.new("user/case-not-ok"))
  end
end
