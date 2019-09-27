defmodule Perspective.Authentication do
  use Perspective.Config

  def authenticate_request(request, token) do
    # @todo: throw if misconfigured
    authentication_module = config(:module)

    authentication_module.authenticate_request(request, token)
  end
end
