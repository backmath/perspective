defmodule Perspective.LoadLocalFile do
  use Perspective.Config, Perspective.LocalFileStorage

  def load(filename, storage_path \\ default_storage_path()) do
    try do
      read_from_disk(filename, storage_path)
      |> decrypt()
      |> decompress()
    rescue
      File.Error -> {:error, Perspective.LocalFileNotFound.exception(filename, storage_path)}
    end
  end

  defp read_from_disk(filename, storage_path) do
    Path.join(storage_path, filename)
    |> File.read!()
  end

  defp decrypt(data) do
    case String.split(data, ".") |> length() do
      3 -> Perspective.Encryption.decrypt(data)
      _ -> data
    end
  end

  defp decompress(data) do
    try do
      :zlib.gunzip(data)
    rescue
      ErlangError -> data
    end
  end

  defp default_storage_path, do: config(:path)
end
