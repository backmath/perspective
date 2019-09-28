defmodule Perspective.Authentication.DefaultAuthenticator do
  @behaviour Perspective.Authenticator

  @impl Perspective.Authenticator
  def authenticate_request(request, _token) do
    Map.put(request, :actor_id, "user/anonymous")
  end
end
