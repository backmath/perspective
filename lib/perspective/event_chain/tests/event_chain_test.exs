defmodule Perspective.EventChain.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "add an event to the event chain" do
    Perspective.Core.AddToDo.new(%{name: "Example Event"})
    |> Perspective.Processor.RequestTransformer.transform()
    |> Perspective.EventChain.apply_event()
  end
end
