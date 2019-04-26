defmodule Perspective.AuthenticationTokenGenerator do
  def hash_password(password) do
    Argon2.hash_pwd_salt(password)
  end

  def generate_authentication_token(username, password) do
    try do
      fetch_node_and_password_hash(username)
      |> verify_password(password)
      |> issue_token
    catch
      error -> {:error, error}
    end
  end

  defp fetch_node_and_password_hash(username) do
    {id, password_hash} =
      case Perspective.AuthenticationVault.credentials_for(username) do
        {:ok, {id, _, password_hash}} -> {id, password_hash}
        {:error, error} -> throw(error)
      end

    Perspective.DomainPool.get(id)
    |> case do
      {:ok, node} -> {node, password_hash}
      {:error, error} -> throw(error)
    end
  end

  defp verify_password({node, password_hash}, password) do
    Argon2.verify_pass(password, password_hash)
    |> case do
      true -> {node, password_hash}
      false -> throw(%Perspective.Authentication.PasswordChallengeFailed{username: node.username})
    end
  end

  defp issue_token({node, _password_hash}) do
    Perspective.Guardian.encode_and_sign(node)
    |> case do
      {:ok, token, _claims} -> token
    end
  end
end