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

  defp action_skips_authentication?(%action_type{} = _action) do
    action_type.skip_authentication?
  end
end
