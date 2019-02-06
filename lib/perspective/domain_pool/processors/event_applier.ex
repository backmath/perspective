defmodule Perspective.MultiNodeEventApplier do
  def apply_event_to_domain_nodes(domain_nodes, event) do
    domain_nodes
    |> asynchronously_apply_event_to_nodes(event)
    |> await_response
    |> aggregate_responses
  end

  defp asynchronously_apply_event_to_nodes(nodes, event) do
    Enum.map(nodes, fn node -> Task.async(fn -> apply_event(node, event) end) end)
  end

  defp apply_event(node, event) do
    Perspective.DomainNode.EventApplier.apply_event(node, event)
  end

  defp await_response(tasks) do
    Enum.map(tasks, &Task.await/1)
  end

  defp aggregate_responses(responses) do
    result =
      responses
      |> Enum.reduce([], fn response, acc ->
        case response do
          {:ok, node} -> [node | acc]
        end
      end)

    {:ok, result}
  end
end
