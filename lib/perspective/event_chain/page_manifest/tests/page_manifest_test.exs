defmodule Perspective.EventChain.PageManifest.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "current_page on boot" do
    current_page = Perspective.EventChain.PageManifest.current_page()

    assert current_page == "event-chain.0000000.json"
  end

  test "add_page persists after an exit" do
    Perspective.EventChain.PageManifest.add_page()

    Perspective.EventChain.PageManifest.call(:name)
    |> GenServer.whereis()
    |> Process.exit(:early_quit)

    current_page =
      Perspective.TestSupport.call_repeatedly(fn ->
        Perspective.EventChain.PageManifest.current_page()
      end)

    pages =
      Perspective.TestSupport.call_repeatedly(fn ->
        Perspective.EventChain.PageManifest.pages()
      end)

    assert current_page == "event-chain.0000001.json"
    assert pages == ["event-chain.0000000.json", "event-chain.0000001.json"]
  end

  test "json encoding/decoding" do
    manifest = Perspective.EventChain.PageManifest.State.new()

    encoded = Perspective.Serialize.to_json(manifest)
    decoded_manifest = Perspective.Deserialize.deserialize(encoded)

    assert decoded_manifest == manifest
  end
end
