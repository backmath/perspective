defmodule Perspective.Processor do
  def run(data, actor_id) do
    generate_request(data)
    |> attach_actor_id(actor_id)
    |> validate_syntax()
    |> register_request()
    |> authorize_request()
    |> validate_semantics()
    |> transform_request_to_event()
    |> apply_to_the_event_chain()
  end

  defp generate_request(data), do: Perspective.Processor.RequestGenerator.generate(data)
  defp attach_actor_id(request, actor_id), do: Map.put(request, :actor_id, actor_id)
  defp validate_syntax(request), do: Perspective.Processor.SyntaxValidator.validate(request)
  defp register_request(request), do: Perspective.RequestRegistry.register(request)
  defp authorize_request(request), do: Perspective.Processor.RequestAuthorizer.authorize(request)
  defp validate_semantics(request), do: Perspective.Processor.SemanticValidator.validate(request)
  defp transform_request_to_event(request), do: Perspective.Processor.RequestTransformer.transform(request)
  defp apply_to_the_event_chain(domain_event), do: Perspective.EventChain.apply_event(domain_event)
end
