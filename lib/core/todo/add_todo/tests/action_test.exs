defmodule Core.AddToDo.Test do
  use ExUnit.Case, async: true

  test "validate_syntax returns an empty list for a valid action" do
    result =
      Core.AddToDo.new("user/abc-123", %{name: "Demonstrate a Valid AddToDo Action"})
      |> Core.AddToDo.validate_syntax()

    assert [] = result
  end

  test "validate_syntax requires a name" do
    result =
      Core.AddToDo.new("user/abc-123", %{name: ""})
      |> Core.AddToDo.validate_syntax()

    assert [{:error, :name, :presence, "must be present"}] == result
  end

  test "domain_event is as expected" do
    assert Core.ToDoAdded == Core.AddToDo.domain_event()
  end
end
