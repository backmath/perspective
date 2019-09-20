defmodule Perspective.Processor.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "example run" do
    Perspective.Core.AddToDo.new("user/josh", %{
      name: "Test Perspective.Processor.run"
    })
    |> Perspective.Processor.run()

    result =
      Perspective.TestSupport.call_repeatedly(fn ->
        Perspective.EventChain.all()
        |> Enum.to_list()
        |> case do
          [] -> raise "event chain returned an empty list"
          [result] -> result
        end
      end)

    assert %Perspective.Core.ToDoAdded{
             actor_id: "user/josh",
             data: %{
               name: "Test Perspective.Processor.run"
             }
           } = result
  end
end
