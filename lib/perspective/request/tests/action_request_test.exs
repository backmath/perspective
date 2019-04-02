defmodule Perspective.ActionRequest.Test do
  use ExUnit.Case

  test "it converts a data set to an action request" do
    data = %{
      name: "Demonstrate how to generate an action from a data struct"
    }

    expected = %Core.AddToDo{
      id: "request:HARD-CODED",
      actor_id: "test:anonymous",
      data: %{
        name: "Demonstrate how to generate an action from a data struct"
      },
      meta: %{
        request_date: "2019-01-01THARD:CODEDZ"
      }
    }

    result =
      Core.AddToDo.new(data, "test:anonymous")
      |> hardcode_request_id
      |> hardcode_meta

    assert result == expected
  end

  defp hardcode_request_id(map), do: Map.put(map, :id, "request:HARD-CODED")
  defp hardcode_meta(map), do: Map.put(map, :meta, %{request_date: "2019-01-01THARD:CODEDZ"})
end
