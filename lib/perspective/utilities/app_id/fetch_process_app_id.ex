defmodule Perspective.FetchProcessAppId do
  def fetch() do
    Process.get(:app_id)
    |> case do
      nil -> nil
      result -> to_string(result)
    end
  end
end
