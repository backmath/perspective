defmodule Perspective.Processor.RequestAuthorizer.Test do
  use ExUnit.Case
  use Perspective.SetUniqueAppID

  setup context do
    Perspective.Core.start(context)
    :ok
  end

  test "invalid syntax raises errors" do
    Perspective.Core.ToDoPool.put!(%{
      id: "todo/abc-123",
      creator_id: "user/josh"
    })

    error =
      assert_raise Perspective.Unauthorized, fn ->
        Perspective.Core.CompleteToDo.new("user/not-josh", %{})
        |> Perspective.Processor.RequestAuthorizer.authorize()
      end

    expected = %Perspective.InvalidSyntax{
      errors: [{:error, :name, :presence, "must be present"}],
      request: %Perspective.Core.AddToDo{
        actor_id: "user/josh",
        data: %{}
      }
    }

    assert expected == error
  end

  test "a valid syntax returns the request" do
    request =
      Perspective.Core.AddToDo.new("user/josh", %{name: "something"})
      |> Perspective.Processor.SyntaxValidator.validate()

    assert %Perspective.Core.AddToDo{data: %{name: "something"}} = request
  end
end
