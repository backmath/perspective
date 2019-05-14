defmodule Perspective.RequestGenerator.Test do
  use ExUnit.Case

  test "generating a request from a struct" do
    result =
      %{
        action: "Core.AddToDo",
        data: %{}
      }
      |> Perspective.RequestGenerator.from()

    assert %Core.AddToDo{} = result
  end
end