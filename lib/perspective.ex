defmodule Perspective do
  use Perspective.Application

  def call!(data, token \\ "") do
    generate_request(data)
    |> authenticate_request(token)
    |> register_request()
    |> queue_request()
  end

  def call(data, token \\ "") do
    try do
      call!(data, token)
    rescue
      error -> {:error, error}
    end
  end

  defp generate_request(data) do
    Perspective.RequestGenerator.from!(data)
  end

  defp authenticate_request(request, token) do
    Perspective.Authentication.authenticate_request(request, token)
  end

  defp register_request(request) do
    Perspective.RequestRegistry.register(request)
  end

  defp queue_request(request) do
    Perspective.Dispatcher.dispatch(request)
  end
end
