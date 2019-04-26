defmodule Perspective.DomainEvent.RequestTransformer.Test do
  use ExUnit.Case

  test "to_event generates the correct event from a request" do
    request = Core.AddToDo.new(%{name: "Example todo"})

    event = Perspective.DomainEvent.RequestTransformer.to_event(request)

    assert event.data.todo_id =~ ~r/todo\/.*/
    assert %DateTime{} = event.event_date
  end

  test "request.id transforms to event.id, and preserves uuid part" do
    request = Core.AddToDo.new(%{name: "Example todo"})
    event = Perspective.DomainEvent.RequestTransformer.to_event(request)

    assert event.id =~ ~r/event\/.*/
    assert Regex.run(~r/(?<=:).*/, event.id) == Regex.run(~r/(?<=:).*/, request.id)
  end
end