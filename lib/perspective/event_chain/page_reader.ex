defmodule Perspective.EventChain.Reader do
  def since(target_id) do
    {:ok, should_drop?} = Agent.start_link(fn -> true end)

    result =
      Stream.drop_while(all(), fn %{id: id} ->
        drop_this_item? = Agent.get(should_drop?, fn result -> result end)

        if target_id == id do
          Agent.update(should_drop?, fn _ -> false end)
        end

        drop_this_item?
      end)

    Process.exit(should_drop?, :normal)

    result
  end

  def all do
    manifest_pages()
    |> read_pages
    |> convert_to_events
  end

  defp manifest_pages do
    Perspective.EventChain.PageManifest.pages()
  end

  defp read_pages(pages) do
    Stream.map(pages, fn page ->
      page
      |> Perspective.StorageConfig.path()
      |> Perspective.LoadLocalFile.load()
    end)
  end

  def convert_to_events(binaries) do
    Stream.flat_map(binaries, fn binary ->
      Perspective.Deserialize.deserialize(binary)
    end)
  end
end
