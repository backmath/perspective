defmodule Perspective.ActionGeneratorTest do
  use ExUnit.Case

  test "it takes a raw struct and generates an action" do
    expected_action = %BackMath.AddToDo{
      actor: "user:bbe22817-5205-47d5-bdca-e4d270e13277",
      request: "request:e008852b-9cbe-4262-bbd1-ad19c4b52de3",
      request_date: "2019-02-07T17:57:06Z",
      references: %{
        parent: "todo:469e2610-4949-458e-8b94-6153b2fe17a7"
      },
      name: "Demonstrate how to generate an action from a data struct"
    }

    assert {:ok, expected_action} == Perspective.ActionGenerator.generate(data())
  end

  test "it yields an error when generating an invalid action" do
    invalid_data = data() |> pop_in([:data, :name]) |> elem(1)

    assert {:error, expected_action} = Perspective.ActionGenerator.generate(invalid_data)
  end

  defp data do
    %{
      action: "BackMath.ToDo",
      request: "request:e008852b-9cbe-4262-bbd1-ad19c4b52de3",
      request_date: "2019-02-07T17:57:06Z",
      actor: "user:bbe22817-5205-47d5-bdca-e4d270e13277",
      references: %{
        parent: "todo:469e2610-4949-458e-8b94-6153b2fe17a7"
      },
      data: %{
        name: "Demonstrate how to generate an action from a data struct"
      }
    }
  end
end
