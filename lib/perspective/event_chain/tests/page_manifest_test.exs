defmodule Perspective.EventChain.PageManifest.Test do
  use ExUnit.Case

  test "add_page" do
    manifest = Perspective.EventChain.PageManifest.State.new()
    :ok = Perspective.EventChain.PageManifest.add_page()

    current_page = Perspective.EventChain.PageManifest.current_page()
    pages = Perspective.EventChain.PageManifest.pages()

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
