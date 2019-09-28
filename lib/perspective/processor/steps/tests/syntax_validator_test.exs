defmodule Perspective.Processor.SyntaxValidator.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "invalid syntax raises errors" do
    error =
      assert_raise Perspective.InvalidSyntax, fn ->
        Perspective.Core.AddToDo.new("user/josh", %{})
        |> Perspective.Processor.SyntaxValidator.validate()
      end

    expected = %Perspective.InvalidSyntax{
      errors: [{:error, :name, :presence, "must be present"}],
      request: %Perspective.Core.AddToDo{
        actor_id: "user/josh",
        data: %{}
      }
    }

    assert expected.errors == error.errors
  end

  test "a valid syntax returns the request" do
    request =
      Perspective.Core.AddToDo.new("user/josh", %{name: "something"})
      |> Perspective.Processor.SyntaxValidator.validate()

    assert %Perspective.Core.AddToDo{data: %{name: "something"}} = request
  end
end
