defmodule Perspective.EventChainBackup.Test do
  use ExUnit.Case

  setup_all do
    File.mkdir_p!("./tmp/#{__MODULE__}/")
    File.rm_rf!("./tmp/#{__MODULE__}/")
  end

  test "backup" do
    Perspective.EventChainBackup.backup()
  end
end
