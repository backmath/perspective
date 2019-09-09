defmodule Perspective.Processor do
  def run(request) do
    request
    |> validate_syntax()
    |> authorize_request()
    |> validate_semantics()
    |> transform_request_to_event()
    |> apply_to_the_event_chain()
  end

  defp validate_syntax(request) do
    case Perspective.ActionRequest.SyntaxValidator.validate_syntax(request) do
      [] -> request
      errors -> reject(request, errors)
    end
  end

  defp authorize_request(request) do
    case Perspective.ActionRequest.RequestAuthorizer.authorize_request(request) do
      true -> request
      [] -> request
      {:error, error} -> reject(request, error)
      errors -> reject(request, errors)
    end
  end

  defp validate_semantics(request) do
    case Perspective.ActionRequest.SemanticValidator.validate_semantics(request) do
      [] -> request
      errors -> reject(request, errors)
    end
  end

  defp transform_request_to_event(request) do
    Perspective.DomainEvent.RequestTransformer.to_event(request)
  end

  defp apply_to_the_event_chain(domain_event) do
    Perspective.EventChain.apply_event(domain_event)
    {:ok, domain_event}
  end

  defmodule RequestRejected do
    defexception [:request]

    def message(error) do
      "The request was rejected (#{Kernel.inspect(error.request)})"
    end
  end

  defp reject(request, errors) do
    raise RequestRejected, request: Map.put(request, :errors, errors)
  end
end
