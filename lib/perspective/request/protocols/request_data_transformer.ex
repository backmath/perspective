defprotocol Perspective.ActionRequest.RequestDataTransformer do
  @fallback_to_any true
  def event_data(request)
end

defimpl Perspective.ActionRequest.RequestDataTransformer, for: Any do
  def event_data(request), do: request.data
end
