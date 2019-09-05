defmodule Perspective.EventChain.SavePageManifest do
  def run(state) do
    state
    |> Perspective.Serialize.to_json()
    |> Perspective.SaveLocalFile.save(file_path())
  end

  defp file_path do
    Perspective.StorageConfig.path("event-chain-manifest.json")
  end
end
