defmodule Perspective.AppID do
  def app_id(opts) do
    app_id =
      case app_id_from_opts(opts) do
        nil -> Perspective.AppIDLookup.fetch_and_set()
        app_id -> app_id
      end

    if app_id == nil do
      raise ArgumentError,
            "\nYou called #{__MODULE__}.call/cast without setting the parent processes' app_id\n\nCall Process.put(:app_id, *process-id*)"
    end

    app_id
  end

  def app_id() do
    app_id([])
  end

  defp app_id_from_opts(opts) when is_list(opts) do
    Keyword.get(opts, :app_id)
  end

  defp app_id_from_opts(%{app_id: app_id}) do
    app_id
  end

  defp app_id_from_opts(_) do
    nil
  end
end
