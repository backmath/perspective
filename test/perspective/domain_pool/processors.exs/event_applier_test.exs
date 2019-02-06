defmodule Perspective.MultiNodeEventApplier.Test do
  use ExUnit.Case
  alias Perspective.MultiNodeEventApplier, as: Subject

  test "empty run" do
    domain_nodes = []
    event = %{}

    assert {:ok, []} = Subject.apply_event_to_domain_nodes(domain_nodes, event)
  end

  test "non-empty run" do
    domain_nodes = [BackMath.ToDo.new()]
    event = %BackMath.ToDoAdded{id: "abc-123", name: "Something ToDo"}

    expected = {:ok, [%BackMath.ToDo{id: "abc-123", name: "Something ToDo"}]}
    assert Subject.apply_event_to_domain_nodes(domain_nodes, event) == expected
  end
end
