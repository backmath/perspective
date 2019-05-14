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

    Perspective.LocalFileStorage.save("abc", "Perspective.LocalFileStorage.Test.data")

    data = Perspective.LocalFileStorage.load("Perspective.LocalFileStorage.Test.data")

    assert "abc" == data
  end
end
