defprotocol Perspective.ActionRequest.RequestAuthorizer do
  @fallback_to_any true
  def authorize(request)
end

defimpl Perspective.ActionRequest.RequestAuthorizer, for: Any do
  def authorize(_request), do: false
end
