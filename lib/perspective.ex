defmodule Perspective do
  def call(token, data) do
    generate_request(data)
    |> authorize_request(token)
    |> register_request
    |> dispatch_request()
  end

  defp generate_request(data), do: Perspective.Request.from(data)

  defp authorize_request(request, token) do
    Perspective.Authorizer.authorize(token)
    |> case do
      {:ok, _request} -> {:ok, request}
    end
  end

  defp dispatch_request({:ok, request}) do
    Perspective.Dispatcher.dispatch(request)
  end

  defp register_request(request) do
    # Perspective.RequestRegistry.register(request)
    request
  end
end

defmodule Perspective.Authorizer do
  def authorize(request, token) do
    # Does token and data actor_id match?
    {:ok, request}
  end
end
