defmodule Perspective.Authentication do
  def authenticate(request, token) do
    token
    |> retrieve_actor
    |> attach_to_request(request)

    # todo action.skip_authentication?
  end

  defp retrieve_actor(""), do: {:ok, %Core.User{id: "user:anonymous"}}
  defp retrieve_actor(nil), do: {:ok, %Core.User{id: "user:anonymous"}}

  defp retrieve_actor(token) do
    Perspective.Guardian.decode_and_verify(token)
    |> case do
      {:ok, claims} -> Perspective.Guardian.resource_from_claims(claims)
      {:error, error} -> {:error, error}
    end
  end

  defp attach_to_request({:ok, actor}, request) do
    {:ok, Map.put(request, :actor_id, actor.id)}
  end

  defp attach_to_request({:error, error}, request) do
    {:error, error}
  end

  def hash_password(password) do
    Argon2.hash_pwd_salt(password)
  end

  def generate_authentication_token(username, password) do
    password_hash =
      case Perspective.AuthenticationVault.password_hash_for(username) do
        {:ok, password_hash} -> password_hash
        {:error, :username_not_found} -> ""
      end

    # case Argon2.verify_pass(password, password_hash) do
    #   true -> {:ok, Perspective.Guardian.encode_and_sign(resource, claims \\ %{}, opts \\ [])}
    # end
  end
end
