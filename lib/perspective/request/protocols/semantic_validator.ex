defprotocol Perspective.ActionRequest.SemanticValidator do
  @fallback_to_any true
  def validate_semantics(request)
end

defimpl Perspective.ActionRequest.SemanticValidator, for: Any do
  def validate_semantics(_request), do: []
end
