defmodule Perspective.DomainNodeFetcher do
  def nodes_for_action(%BackMath.AddToDo{} = _action) do
    [BackMath.ToDo.new()]
  end
end
