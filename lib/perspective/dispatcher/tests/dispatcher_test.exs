defmodule Perspective.Dispatcher.Test do
  use ExUnit.Case

  test "begin process of dispatching JSON / struct data to action to correct processor" do
    assert {:ok, something} = Perspective.Dispatcher.dispatch(example_request())
  end

  def example_request do
    %{
      action: "BackMath.AddToDo",
      request: "request:e008852b-9cbe-4262-bbd1-ad19c4b52de3",
      actor: "user:bbe22817-5205-47d5-bdca-e4d270e13277",
      data: %{
        name: "Demonstrate how to generate an action from a data struct"
      }
    }
    |> Perspective.RequestGenerator.from()
  end
end
