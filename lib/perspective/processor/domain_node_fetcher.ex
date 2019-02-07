defmodule Perspective.DomainNodeFetcher do
  def nodes_for_action(%BackMath.AddToDo{} = _action) do
    [%BackMath.ToDo{}]
  end

  def nodes_for_action(%type{} = _action) do
    raise ArgumentError,
          "The action #{type} has no matching Perspective.DomainNodeFetcher.nodes_for_action/1 clause"
  end
end
