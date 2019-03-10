defmodule Perspective do
  def call(data, token \\ "") do
    generate_request(data)
    |> authenticate_request(token)
    |> queue_request()
  end

  defp generate_request(data), do: Perspective.RequestGenerator.from(data)

  defp authenticate_request(request, token) do
    Perspective.Authentication.authenticate(request, token)
  end

  defp register_request(request) do
    # Perspective.RequestRegistry.register(request)
  end

  defp queue_request({:ok, request}) do
    # Rename to dispatcher queue, or similar
    Perspective.Dispatcher.dispatch(request)
    request
  end
end
