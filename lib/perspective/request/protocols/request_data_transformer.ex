defprotocol Perspective.ActionRequest.RequestDataTransformer do
  @fallback_to_any true
  def transform_data(request)
end

defimpl Perspective.ActionRequest.RequestDataTransformer, for: Any do
  def transform_data(request), do: request.data
end
