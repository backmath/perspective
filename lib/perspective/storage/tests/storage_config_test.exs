defmodule Perspective.StorageConfig.Test do
  use ExUnit.Case

  setup do
    on_exit(fn ->
      File.rm("./storage/test/storage-config.json")
    end)
  end

  test "generate a keyed path" do
    %{"key" => old_key} =
      Regex.named_captures(~r|\./storage/test/(?<key>.*)/abc\.json|, Perspective.StorageConfig.path("abc.json"))

    Perspective.StorageConfig.set_new_key()

    %{"key" => new_key} =
      Regex.named_captures(~r|\./storage/test/(?<key>.*)/abc\.json|, Perspective.StorageConfig.path("abc.json"))

    assert old_key != new_key

    # @todo = assert key is uuid
  end
end
