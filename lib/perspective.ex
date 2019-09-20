defmodule Perspective do
  use Perspective.Application

  def call(data, token \\ "") do
    try do
      generate_request(data)
      |> authenticate_request(token)
      |> register_request()
      |> queue_request()
    rescue
      e -> e
    end
  end

  def call!(data, token \\ "") do
    case call(data, token) do
      {:error, error} -> raise error
      value -> value
    end
  end

  defp generate_request(data) do
    Perspective.RequestGenerator.from(data)
    |> raise_errors
  end

  defp authenticate_request(request, token) do
    Perspective.Authentication.authenticate_request(request, token)
    |> raise_errors
  end

  defp register_request(request) do
    Perspective.RequestRegistry.register(request)
    |> raise_errors
  end

  defp queue_request(request) do
    Perspective.Dispatcher.dispatch(request)
    |> raise_errors
  end

  defp raise_errors({:error, error}) do
    raise error
  end

  defp raise_errors(pass_through) do
    pass_through
  end
end
