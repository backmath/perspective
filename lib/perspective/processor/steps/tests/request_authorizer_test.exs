defmodule Perspective.Processor.RequestAuthorizer.Test do
  use ExUnit.Case

  defmodule Example do
    use Perspective.ActionRequest
    domain_event(Perspective.Processor.RequestAuthorizer.Test.ExampleEvent, "1.0")

    authorize(%{actor_id: "user/true"}) do
      true
    end

    authorize(%{actor_id: "user/ok"}) do
      true
    end

    authorize(%{actor_id: "user/false"}) do
      false
    end

    authorize(%{actor_id: "user/error"}) do
      {:error, :extra_error}
    end
  end

  test "true and ok response return the request" do
    request = Example.new("user/true")

    assert request == Perspective.Processor.RequestAuthorizer.authorize(request)

    request = Example.new("user/ok")

    assert request == Perspective.Processor.RequestAuthorizer.authorize(request)
  end

  test "false failures throw an error" do
    assert_raise Perspective.Unauthorized, fn ->
      Example.new("user/false")
      |> Perspective.Processor.RequestAuthorizer.authorize()
    end
  end

  test "error tuples throw an error with the errors attached" do
    error =
      assert_raise Perspective.Unauthorized, fn ->
        Example.new("user/error")
        |> Perspective.Processor.RequestAuthorizer.authorize()
      end

    assert [:extra_error] == error.errors
  end

  test "default failures" do
    assert_raise Perspective.Unauthorized, fn ->
      Example.new("user/missing")
      |> Perspective.Processor.RequestAuthorizer.authorize()
    end
  end
end
