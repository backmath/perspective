defmodule Perspective.ActionProcessor do
  def run(data) do
    action = BackMath.AddToDo.new(data)

    domain_nodes = domain_nodes_for(action)

    event = Perspective.ActionTransformer.transform(action)

    Perspective.MultiNodeEventApplier.apply_event_to_domain_nodes(domain_nodes, event)
  end

  defp domain_nodes_for(_action) do
    [%BackMath.ToDo{id: "", name: ""}]
  end
end

defmodule Perspective.DomainNodeFetcher do
  def nodes_for_action(%BackMath.AddToDo{} = _action) do
    [BackMath.ToDo.new()]
  end
end
