defmodule Perspective.LocalFileStorage.Test do
  use ExUnit.Case

  setup do
    case File.rm("./storage/test/Perspective.LocalFileStorage.Test.data") do
      :ok -> :ok
      {:error, :enoent} -> :ok
    end
  end

  test "save and load from a file" do
    assert false == File.exists?("./storage/test/Perspective.LocalFileStorage.Test.data")

    Perspective.SaveLocalFile.save("abc", "Perspective.LocalFileStorage.Test.data")

    result = Perspective.LoadLocalFile.load("Perspective.LocalFileStorage.Test.data")

    assert "abc" == result
  end

  test "load a missing file" do
    assert false == File.exists?("./storage/test/Perspective.LocalFileStorage.Test.data")

    result = Perspective.LoadLocalFile.load("Perspective.LocalFileStorage.Test.data")

    assert {:error, %Perspective.LocalFileNotFound{}} = result
  end
end
