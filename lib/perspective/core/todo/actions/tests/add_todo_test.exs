defmodule Perspective.Core.AddToDo.Test do
  use ExUnit.Case, async: true

  test "validate_syntax returns an empty list for a valid action" do
    result =
      Perspective.Core.AddToDo.new("user/abc-123", %{name: "Demonstrate a Valid AddToDo Action"})
      |> Perspective.Core.AddToDo.validate_syntax()

    assert [] = result
  end

  test "validate_syntax requires a name" do
    result =
      Perspective.Core.AddToDo.new("user/abc-123", %{name: ""})
      |> Perspective.Core.AddToDo.validate_syntax()

    assert [{:error, :name, :presence, "must be present"}] == result
  end

  test "transform_data generates a todo_id" do
    data =
      Perspective.Core.AddToDo.new("user/abc-123", %{name: "Demonstrate a Valid AddToDo Action"})
      |> Perspective.Core.AddToDo.transform_data()

    assert data.name =~ "Demonstrate a Valid AddToDo Action"
    assert data.todo_id =~ ~r/todo\/.*/
  end

  test "action requests transform to a domain event as expected" do
    event =
      Perspective.Core.AddToDo.new("user/abc-123", %{name: "Demonstrate a Valid AddToDo Action"})
      |> Perspective.Processor.RequestTransformer.transform()

    assert %Perspective.Core.ToDoAdded{version: "1.0"} = event
  end
end
