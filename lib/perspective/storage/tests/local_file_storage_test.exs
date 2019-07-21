defmodule Perspective.LocalFileStorage.Test do
  use ExUnit.Case

  setup do
    case File.rm("./storage/test/Perspective.LocalFileStorage.Test.data") do
      :ok -> :ok
      {:error, :enoent} -> :ok
    end

    on_exit(fn ->
      File.rm("./storage/test/Perspective.LocalFileStorage.Test.data")
    end)
  end

  test "save and load from a file" do
    assert false == File.exists?("./storage/test/Perspective.LocalFileStorage.Test.data")

    Perspective.SaveLocalFile.save("abc", "./storage/test/Perspective.LocalFileStorage.Test.data")

    result = Perspective.LoadLocalFile.load("./storage/test/Perspective.LocalFileStorage.Test.data")

    assert "abc" == result
  end

  test "load a missing file" do
    assert false == File.exists?("./storage/test/Perspective.LocalFileStorage.Test.data")

    result = Perspective.LoadLocalFile.load("./storage/test/Perspective.LocalFileStorage.Test.data")

    assert {:error, %Perspective.LocalFileNotFound{}} = result
  end

  test "load! a missing file" do
    assert false == File.exists?("./storage/test/Perspective.LocalFileStorage.Test.data")

    assert_raise Perspective.LocalFileNotFound, fn ->
      Perspective.LoadLocalFile.load!("./storage/test/Perspective.LocalFileStorage.Test.data")
    end
  end

  test "save a file to a missing directory creates that directory" do
    Perspective.StorageConfig.set_new_key()

    path = Perspective.StorageConfig.path("Perspective.LocalFileStorage.Test.data")

    Perspective.SaveLocalFile.save("abc", path)

    result = Perspective.LoadLocalFile.load(path)

    assert result == "abc"
  end
end
