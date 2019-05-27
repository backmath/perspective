defmodule Perspective.EventChain.Test do
  use ExUnit.Case

  test "add an event to the event chain" do
    Core.AddToDo.new(%{name: "Example Event"})
    |> Perspective.DomainEvent.RequestTransformer.to_event()
    |> Perspective.EventChain.apply_event()

    # assert
  end
end
