defmodule Perspective.FetchProcessAppId do
  def fetch() do
    Process.get(:app_id)
    |> to_string()
  end
end
