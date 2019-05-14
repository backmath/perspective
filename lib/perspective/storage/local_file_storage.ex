defmodule Perspective.LocalFileStorage do
  use Perspective.Config

  def save(data, filename, storage_path \\ default_storage_path()) do
    data
    |> compress()
    |> encrypt()
    |> write_to_disk(filename, storage_path)
  end

  defp compress(data), do: :zlib.gzip(data)
  defp encrypt(data), do: Perspective.Encryption.encrypt(data)

  defp write_to_disk(data, filename, storage_path) do
    Path.join(storage_path, filename)
    |> File.write!(data)
  end

  defp default_storage_path, do: config(:path)

  def load(filename, storage_path \\ default_storage_path()) do
    read_from_disk(filename, storage_path)
    |> decrypt()
    |> decompress()
  end

  defp read_from_disk(filename, storage_path) do
    Path.join(storage_path, filename)
    |> File.read!()
  end

  defp decrypt(data), do: Perspective.Encryption.decrypt(data)
  defp decompress(data), do: :zlib.gunzip(data)
end
