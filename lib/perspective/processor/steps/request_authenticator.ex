defmodule Perspective.Processor.RequestAuthenticator do
  use Perspective.Config

  @behaviour Perspective.RequestAuthenticator

  @impl Perspective.RequestAuthenticator
  def authenticate(request, token) do
    # @todo: throw if misconfigured
    authentication_module = config(:module)

    case authentication_module.authenticate_request(request, token) do
      {:error, error} -> raise error
      # Propbably must change
      %{errors: errors} -> raise errors
      value -> value
    end
  end
end
