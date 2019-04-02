defprotocol Perspective.ActionRequest.SyntaxValidator do
  @fallback_to_any true
  def validate_syntax(request)
end

defimpl Perspective.ActionRequest.SyntaxValidator, for: Any do
  def validate_syntax(_request), do: []
end
