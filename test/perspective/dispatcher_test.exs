defmodule Perspective.Dispatcher.Test do
  use ExUnit.Case

  test "begin process of dispatching JSON / struct data to action to correct processor" do
    assert {:ok, something} = Perspective.Dispatcher.dispatch(example_request())
  end

  def example_request do
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
