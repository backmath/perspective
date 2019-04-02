defprotocol Perspective.ActionRequest.RequestAuthorizer do
  @fallback_to_any true
  def authorize_request(request)
end

defimpl Perspective.ActionRequest.RequestAuthorizer, for: Any do
  def authorize_request(_request), do: []
end
