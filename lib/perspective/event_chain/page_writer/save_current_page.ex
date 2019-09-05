defmodule Perspective.EventChain.SaveCurrentPage do
  def run do
    current_page_path =
      Perspective.EventChain.PageManifest.current_page()
      |> Perspective.StorageConfig.path()

    Perspective.EventChain.CurrentPage.events()
    |> Perspective.Serialize.to_json()
    |> Perspective.SaveLocalFile.save(current_page_path)
  end
end
