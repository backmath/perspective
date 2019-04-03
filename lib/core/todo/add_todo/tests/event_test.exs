defmodule Core.ToDoAdded.Test do
  use ExUnit.Case

  test "transform_data generates a todo_id" do
    data =
      Core.AddToDo.new(%{name: "Demonstrate a Valid AddToDo Action"})
      |> Core.ToDoAdded.transform_data()

    assert data.name =~ "Demonstrate a Valid AddToDo Action"
    assert data.todo_id =~ ~r/todo\/.*/
  end
end
