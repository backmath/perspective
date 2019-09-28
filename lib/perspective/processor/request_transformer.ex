defmodule Perspective.Processor.RequestTransformer do
  def to_event(request) do
    request
    |> initialize_event
    |> transform_id_from_request_to_event
    |> set_the_event_date
    |> set_the_domain_event_version(request)
    |> transform_the_data(request)
    |> transform_the_metadata(request)
  end

  defp initialize_event(%action_request{} = request) do
    struct(action_request.domain_event_name(), Map.from_struct(request))
  end

  defp transform_id_from_request_to_event(event) do
    Map.put(event, :id, String.replace(event.id, ~r/request/, "event"))
  end

  defp set_the_event_date(event) do
    Map.put(event, :event_date, DateTime.utc_now())
  end

  defp set_the_domain_event_version(event, %action_request{}) do
    Map.put(event, :version, action_request.domain_event_version())
  end

  defp transform_the_data(event, request) do
    Map.put(event, :data, Perspective.ActionRequest.RequestDataTransformer.transform_data(request))
  end

  defp transform_the_metadata(event, request) do
    Map.put(event, :meta, Perspective.ActionRequest.MetadataTransformer.transform_meta(request))
  end
end
