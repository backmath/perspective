defmodule Perspective.EventChain.LoadPageManifest do
  def load_manifest do
    case Perspective.LoadLocalFile.load(file_path()) do
      {:error, %Perspective.LocalFileNotFound{}} -> create_manifest()
      data -> data
    end
    |> Perspective.Deserialize.deserialize()
  end

  defp file_path do
    Perspective.StorageConfig.path("event-chain-manifest.json")
  end

  defp create_manifest do
    Perspective.EventChain.SavePageManifest.run(Perspective.EventChain.PageManifest.State.new())
    Perspective.LoadLocalFile.load(file_path())
  end
end
