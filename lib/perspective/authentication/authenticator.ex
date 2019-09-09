defmodule Perspective.Authenticator do
  def authenticate_request(request, token) do
    token
    |> retrieve_actor
    |> attach_to_request(request)
  end

  defp retrieve_actor(""), do: {:ok, %Core.User{id: "user/anonymous"}}
  defp retrieve_actor(nil), do: {:ok, %Core.User{id: "user/anonymous"}}
  # User not found
  defp retrieve_actor({:error, error}), do: {:error, error}

  defp retrieve_actor(token) do
    Perspective.Guardian.decode_and_verify(token)
    |> case do
      {:ok, claims} -> Perspective.Guardian.resource_from_claims(claims)
      {:error, error} -> {:error, error}
    end
  end

  defp attach_to_request({:ok, actor}, request) do
    Map.put(request, :actor_id, actor.id)
  end

  defp attach_to_request({:error, error}, request) do
    Map.put(request, :errors, [error])
  end
end
