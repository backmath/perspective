defmodule Perspective.Processor do
  def run(request) do
    domain_nodes = Perspective.DomainNodeFetcher.nodes_for_action(request.action)

    event = Perspective.ActionTransformer.transform(request.action)

    {:ok, _nodes} = Perspective.MultiNodeEventApplier.apply_event_to_domain_nodes(domain_nodes, event)

    Perspective.EventChain.apply_event(event)

    {:ok, request.action}
  end
end
