defmodule Perspective.GenServer.ProcessIdentifiers do
  def store(module, opts) do
    fetch_and_set_app_id(opts)
    Process.put(:uri, module.uri(opts))
    Process.put(:name, module.name(opts))
    Process.put(:module, module)
  end

  defp fetch_and_set_app_id(opts) do
    Perspective.AppID.app_id(opts)
    |> Perspective.SetAppId.set()
  end
end
