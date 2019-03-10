defmodule Perspective.Processor do
  def run(request) do
    # Validate syntax
    validate_action(request.action)

    # todo: Validate Domain integrity

    domain_event = transform_request_to_event(request)

    apply_to_the_event_chain(domain_event)

    {:ok, domain_event}
  end

  defp validate_action(%action_type{} = action) do
    action_type.valid?(action)
  end

  defp transform_request_to_event(request) do
    event = Perspective.ActionTransformer.transform(request.action)

    %Perspective.DomainEvent{
      actor_id: request.actor_id,
      event_id: request.request_id,
      event_date: DateTime.utc_now() |> DateTime.to_iso8601(),
      request_date: request.request_date,
      event_type: event.__struct__ |> to_string |> String.replace(~r/^Elixir./, ""),
      event: event
    }
  end

  defp apply_to_the_event_chain(domain_event) do
    Perspective.EventChain.apply_event(domain_event)
    domain_event
  end
end
