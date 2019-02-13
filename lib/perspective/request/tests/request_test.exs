defmodule Perspective.Request.Test do
  use ExUnit.Case

  test "it converts a data set to an action request" do
    data = %{
      action: "BackMath.AddToDo",
      request: "request:abc-123",
      actor: "user:john-adams",
      data: %{
        name: "Demonstrate how to generate an action from a data struct"
      }
    }

    expected = %Perspective.ActionRequest{
      actor: "user:john-adams",
      request: "request:abc-123",
      action: %BackMath.AddToDo{
        name: "Demonstrate how to generate an action from a data struct"
      }
    }

    result = Perspective.Request.from(data) |> remove_date

    assert result == expected
  end

  test "yields an error in the case of a missing action" do
    data = %{
      action: "Non.Existent.Action",
      request: "",
      actor: "",
      data: %{}
    }

    result = Perspective.Request.from(data)

    assert {:error, %Perspective.Request.MissingAction{action_name: "Non.Existent.Action"}} == result
  end

  defp remove_date(map), do: Map.put(map, :date, "")
end