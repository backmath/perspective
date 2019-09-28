defmodule Perspective do
  use Perspective.Application

  def call!(data, token \\ "") do
    generate_request(data)
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

  defp queue_request(request) do
    Perspective.Dispatcher.dispatch(request)
  end
end
