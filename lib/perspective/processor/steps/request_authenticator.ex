defmodule Perspective.Processor.RequestAuthenticator do
  use Perspective.Config

  @behaviour Perspective.RequestAuthenticator

  @impl Perspective.RequestAuthenticator
  def authenticate(request, token) do
    authentication_module = config(:module)

    case authentication_module.authenticate(request, token) do
      {:error, error} -> raise error
      # Propbably must change
      %{errors: errors} -> raise errors
      value -> value
    end
  end
end
