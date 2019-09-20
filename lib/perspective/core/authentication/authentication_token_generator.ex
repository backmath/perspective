defmodule Perspective.Core.AuthenticationTokenGenerator do
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
      case Perspective.Core.AuthenticationVault.credentials_for(username) do
        {:ok, %{user_id: id, password_hash: password_hash}} -> {id, password_hash}
        {:error, error} -> throw(error)
      end

    {%Perspective.Core.User{id: id, username: username}, password_hash}
  end

  defp verify_password({node, password_hash}, password) do
    Argon2.verify_pass(password, password_hash)
    |> case do
      true -> {node, password_hash}
      false -> throw(%Perspective.Authentication.PasswordChallengeFailed{username: node.username})
    end
  end

  defp issue_token({node, _password_hash}) do
    Perspective.Core.Guardian.encode_and_sign(node)
    |> case do
      {:ok, token, _claims} -> token
    end
  end
end
