defmodule Perspective.AppIdFromConfiguration do
  def find do
    Application.fetch_env(:perspective, Perspective.Application)
    |> case do
      {:ok, list} -> list
      _ -> []
    end
    |> Keyword.fetch(:app_id)
    |> case do
      {:ok, app_id} -> app_id
      :error -> nil
    end
  end
end
