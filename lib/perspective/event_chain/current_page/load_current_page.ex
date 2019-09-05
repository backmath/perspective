defmodule Perspective.EventChain.LoadCurrentPage do
  def run do
    Perspective.EventChain.PageManifest.current_page()
    |> Perspective.StorageConfig.path()
    |> Perspective.LoadLocalFile.load()
    |> case do
      {:error, %Perspective.LocalFileNotFound{}} -> save_and_load_new_page()
      data -> data
    end
    |> Perspective.Deserialize.deserialize()
  end

  defp save_and_load_new_page do
    path =
      Perspective.EventChain.PageManifest.current_page()
      |> Perspective.StorageConfig.path()

    Perspective.SaveLocalFile.save("[]", path)

    Perspective.LoadLocalFile.load(path)
  end
end
