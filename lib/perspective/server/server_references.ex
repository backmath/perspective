defmodule Perspective.ServerReferences do
  def store_process_references(module, opts) do
    Process.put(:app_id, app_id(opts))
    Process.put(:name, name(module, opts))
    Process.put(:module, module)
  end

  defp name(module, options) when is_list(options) do
    Keyword.get(options, :name, Perspective.GenServer.Names.name(module, options))
  end

  defp name(module, options) when is_map(options) do
    Map.get(options, :name, Perspective.GenServer.Names.name(module, options))
  end

  defp app_id(opts) when is_list(opts) do
    Keyword.get(opts, :app_id)
  end

  defp app_id(%{app_id: app_id}) do
    app_id
  end

  defp app_id(_) do
    nil
  end
end
