defmodule Perspective.Processor do
  def run(request, token) do
    request
    |> validate_syntax()
    |> authenticate_request(token)
    |> authorize_request()
    |> validate_semantics()
    |> transform_request_to_event()
    |> apply_to_the_event_chain()
  end

  defp validate_syntax(request), do: Perspective.Processor.SyntaxValidator.validate(request)
  defp authenticate_request(request, token), do: Perspective.Processor.RequestAuthenticator.authenticate(request, token)
  defp authorize_request(request), do: Perspective.Processor.RequestAuthorizer.authorize(request)
  defp validate_semantics(request), do: Perspective.Processor.SemanticValidator.validate(request)
  defp transform_request_to_event(request), do: Perspective.Processor.RequestTransformer.transform(request)
  defp apply_to_the_event_chain(domain_event), do: Perspective.EventChain.apply_event(domain_event)
end
