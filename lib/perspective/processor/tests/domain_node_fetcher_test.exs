defmodule Perspective.DomainNodeFetcher.Test do
  use ExUnit.Case
  alias Perspective.DomainNodeFetcher, as: Subject

  test "nodes for the action Core.AddToDo returns an empty node" do
    result = Subject.nodes_for_action(%Core.AddToDo{})
    assert [%Core.ToDo{}] = result
  end

  defstruct example: true

  test "nodes for an unmatched action throws an error" do
    assert_raise(
      ArgumentError,
      "The action Elixir.Perspective.DomainNodeFetcher.Test has no matching Perspective.DomainNodeFetcher.nodes_for_action/1 clause",
      fn ->
        Subject.nodes_for_action(%Perspective.DomainNodeFetcher.Test{})
      end
    )
  end
end
