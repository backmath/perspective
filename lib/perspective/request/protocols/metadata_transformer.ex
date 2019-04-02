defprotocol Perspective.ActionRequest.MetadataTransformer do
  @fallback_to_any true
  def event_meta(request)
end

defimpl Perspective.ActionRequest.MetadataTransformer, for: Any do
  def event_meta(%_{} = request), do: request.meta
end
