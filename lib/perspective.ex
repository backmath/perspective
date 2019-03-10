defmodule Perspective do
  def call(data, token \\ "") do
    generate_request(data)
    |> authenticate_request(token)
    |> register_request
    |> queue_request()
  end

  defp generate_request(data), do: Perspective.RequestGenerator.from(data)

  defp authenticate_request(request, token) do
    Perspective.Authentication.authenticate(request, token)
  end

  defp action_skips_authentication?(%action_type{} = _action) do
    IO.inspect(action_type)
    IO.inspect(action_type.skip_authentication?)
    action_type.skip_authentication?
  end

  defp queue_request({:ok, request}) do
    # Rename to dispatcher queue, or similar
    Perspective.Dispatcher.dispatch(request)
  end

  defp register_request(request) do
    # Perspective.RequestRegistry.register(request)
    request
  end
end
