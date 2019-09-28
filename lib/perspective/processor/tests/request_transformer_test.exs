defmodule Perspective.Processor.RequestTransformer.Test do
  use ExUnit.Case, async: true

  test "to_event generates the correct event from a request" do
    request = Perspective.Core.AddToDo.new(%{name: "Example todo"})

    event = Perspective.Processor.RequestTransformer.to_event(request)

    assert event.data.todo_id =~ ~r/todo\/.*/
    assert %DateTime{} = event.event_date
  end

  test "request.id transforms to event.id, and preserves uuid part" do
    request = Perspective.Core.AddToDo.new(%{name: "Example todo"})
    event = Perspective.Processor.RequestTransformer.to_event(request)

    assert event.id =~ ~r/event\/.*/
    assert Regex.run(~r/(?<=:).*/, event.id) == Regex.run(~r/(?<=:).*/, request.id)
  end
end
