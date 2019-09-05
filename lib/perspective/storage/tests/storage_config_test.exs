defmodule Perspective.StorageConfig.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "a path uses the configured storage path and app_id", %{app_id: app_id} do
    result = Perspective.StorageConfig.path("some-file.json")

    assert "./storage/test/#{app_id}/some-file.json" == result
  end
end
