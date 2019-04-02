defmodule Perspective.DomainEvent.RequestTransformer do
  def to_event(%request_name{} = request) do
    struct(request_name.event_name, Map.from_struct(request))
    |> Map.put(:id, String.replace(request.id, ~r/request/, "event"))
    |> Map.put(:event_date, DateTime.utc_now())
    |> Map.put(:data, Perspective.ActionRequest.RequestDataTransformer.event_data(request))
    |> Map.put(:meta, Perspective.ActionRequest.MetadataTransformer.event_meta(request))
  end
end
