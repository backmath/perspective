defmodule Perspective.Processor.RequestGenerator.Test do
  use ExUnit.Case, async: true

  test "generating a request from a map" do
    result =
      %{
        action: "Perspective.Core.AddToDo",
        data: %{}
      }
      |> Perspective.Processor.RequestGenerator.generate()

    assert %Perspective.Core.AddToDo{} = result
  end

  test "generating a request from a struct" do
    result =
      %Perspective.Core.AddToDo{
        data: %{}
      }
      |> Perspective.Processor.RequestGenerator.generate()

    assert %Perspective.Core.AddToDo{} = result
  end
end
