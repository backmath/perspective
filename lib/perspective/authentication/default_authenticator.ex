defmodule Perspective.Authentication.DefaultAuthenticator do
  def authenticate_request(request, _token) do
    Map.put(request, :actor_id, "user/anonymous")
  end
end
