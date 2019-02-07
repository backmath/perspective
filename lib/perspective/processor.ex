defmodule Perspective.Processor do
  def run(action) do
    domain_nodes = Perspective.DomainNodeFetcher.nodes_for_action(action)

    event = Perspective.ActionTransformer.transform(action)

    {:ok, _nodes} = Perspective.MultiNodeEventApplier.apply_event_to_domain_nodes(domain_nodes, event)

    Perspective.EventChain.apply_event(event)

    {:ok, action}
  end
end
