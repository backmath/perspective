defmodule Perspective.Test do
  use ExUnit.Case

  test "test a basic perspective call" do
    %{
      action: "Core.AddToDo",
      data: %{
        name: "Build my First ToDo"
      }
    }
    |> Perspective.call()
  end
end
