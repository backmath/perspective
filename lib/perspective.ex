defmodule Perspective do
  def call(data, token \\ "") do
    generate_request(data)
    |> authorize_request(token)
    |> register_request
    |> queue_request()
  end

  defp generate_request(data), do: Perspective.RequestGenerator.from(data)

  defp authorize_request(request, token) do
    Perspective.Authorizer.authorize(request, token)
    |> case do
      {:ok, _request} -> {:ok, request}
    end
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
