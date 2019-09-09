defmodule Perspective.Processor.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "example run" do
    Core.AddToDo.new("user/josh", %{
      name: "Test Perspective.Processor.run"
    })
    |> Perspective.Processor.run()

    result =
      Perspective.TestSupport.call_repeatedly(fn ->
        Perspective.EventChain.all()
        |> Enum.to_list()
        |> case do
          [] -> raise "Fail"
          [result] -> result
        end
      end)

    assert %Core.ToDoAdded{
             actor_id: "user/josh",
             data: %{
               name: "Test Perspective.Processor.run"
             }
           } = result
  end
end
