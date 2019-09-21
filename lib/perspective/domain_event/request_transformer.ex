defmodule Perspective.DomainEvent.RequestTransformer do
  def to_event(%action_request{} = request) do
    struct(action_request.domain_event_name(), Map.from_struct(request))
    |> Map.put(:id, String.replace(request.id, ~r/request/, "event"))
    |> Map.put(:event_date, DateTime.utc_now())
    |> Map.put(:version, action_request.domain_event_version())
    |> Map.put(:data, Perspective.ActionRequest.RequestDataTransformer.transform_data(request))
    |> Map.put(:meta, Perspective.ActionRequest.MetadataTransformer.transform_meta(request))
  end
end
