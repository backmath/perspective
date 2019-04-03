defprotocol Perspective.ActionRequest.MetadataTransformer do
  @fallback_to_any true
  def transform_meta(request)
end

defimpl Perspective.ActionRequest.MetadataTransformer, for: Any do
  def transform_meta(%_{} = request), do: request.meta
end
