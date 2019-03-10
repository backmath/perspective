defmodule Perspective.Request.Test do
  use ExUnit.Case

  test "it converts a data set to an action request" do
    data = %{
      action: "Core.AddToDo",
      actor_id: "user:john-adams",
      data: %{
        name: "Demonstrate how to generate an action from a data struct"
      }
    }

    expected = %Perspective.ActionRequest{
      request_id: "request:HARD-CODED",
      request_date: "2019-01-01THARD:CODEDZ",
      actor_id: "user:john-adams",
      action: %Core.AddToDo{
        name: "Demonstrate how to generate an action from a data struct"
      }
    }

    result =
      Perspective.RequestGenerator.from(data)
      |> hardcode_request_id
      |> hardcode_request_date

    assert result == expected
  end

  test "yields an error in the case of a missing action" do
    data = %{
      action: "Non.Existent.Action",
      request: "",
      actor: "",
      data: %{}
    }

    result = Perspective.RequestGenerator.from(data)

    assert {:error, %Perspective.Request.MissingAction{action_name: "Non.Existent.Action"}} == result
  end

  defp hardcode_request_id(map), do: Map.put(map, :request_id, "request:HARD-CODED")
  defp hardcode_request_date(map), do: Map.put(map, :request_date, "2019-01-01THARD:CODEDZ")
end
