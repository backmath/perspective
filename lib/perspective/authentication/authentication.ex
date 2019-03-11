defmodule Perspective.Authentication do
  def authenticate(request, token) do
    case action_skips_authentication?(request.action) do
      true -> {:ok, %{"sub" => "user:anonymous"}}
      false -> Perspective.Guardian.decode_and_verify(token)
    end
    |> case do
      {:ok, claims} -> {:ok, Map.put(request, :actor_id, claims["sub"])}
      error -> error
    end
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

    case Argon2.verify_pass(password, password_hash) do
      true -> {:ok, Perspective.Guardian.encode_and_sign(resource, claims \\ %{}, opts \\ [])}
    end
  end

  defp action_skips_authentication?(%action_type{} = _action) do
    action_type.skip_authentication?
  end
end
