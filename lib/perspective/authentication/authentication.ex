defmodule Perspective.Authentication do
  use Perspective.Config

  def authenticate_request(request, token) do
    authentication_module = config(:module)

    authentication_module.authenticate_request(request, token)
  end
end
