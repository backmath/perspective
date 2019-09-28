defmodule Perspective.Authentication.DefaultAuthenticator do
  @behaviour Perspective.RequestAuthenticator

  @impl Perspective.RequestAuthenticator
  def authenticate(request, _token) do
    Map.put(request, :actor_id, "user/anonymous")
  end
end
