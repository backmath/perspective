defmodule Perspective.RequestGenerator.Test do
  use ExUnit.Case, async: true

  test "generating a request from a struct" do
    result =
      %{
        action: "Perspective.Core.AddToDo",
        data: %{}
      }
      |> Perspective.RequestGenerator.from()

    assert %Perspective.Core.AddToDo{} = result
  end
end
