defmodule Perspective.EventChain.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "add an event to the event chain" do
    Perspective.Core.AddToDo.new(%{name: "Example Event"})
    |> Perspective.DomainEvent.RequestTransformer.to_event()
    |> Perspective.EventChain.apply_event()
  end
end
