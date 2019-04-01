defmodule Perspective.Processor do
  def run(request) do
    # authorize request (not authenticate)

    # Validate syntax
    case valid_action?(request.action) do
      true -> complete_request(request)
      false -> validation_errors(request.action)
    end
  end

  defp valid_action?(%action_type{} = action) do
    action_type.valid?(action)
  end

  defp validation_errors(%action_type{} = action) do
    action_type.errors?(action)
  end

  defp complete_request(request) do
    request
    |> transform_request_to_event()
    |> apply_to_the_event_chain()
  end

  defp transform_request_to_event(request) do
    Perspective.ActionTransformer.transform(request.action)
  end

  defp apply_to_the_event_chain(domain_event) do
    Perspective.EventChain.apply_event(domain_event)
    {:ok, domain_event}
  end
end
