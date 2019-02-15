defmodule Perspective.DomainNodeFetcher do
  def nodes_for_action(%Core.AddToDo{} = _action) do
    [%Core.ToDo{}]
  end

  def nodes_for_action(%type{} = _action) do
    raise ArgumentError,
          "The action #{type} has no matching Perspective.DomainNodeFetcher.nodes_for_action/1 clause"
  end
end
