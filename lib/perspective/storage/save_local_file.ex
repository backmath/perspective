defmodule Perspective.SaveLocalFile do
  use Perspective.Config, Perspective.LocalFileStorage

  def save(data, filename, storage_path \\ default_storage_path()) do
    data
    |> compress()
    |> encrypt()
    |> write_to_disk(filename, storage_path)
  end

  defp compress(data) do
    case skip_compression?() do
      true -> data
      _ -> :zlib.gzip(data)
    end
  end

  defp encrypt(data) do
    case skip_encryption?() do
      true -> data
      _ -> Perspective.Encryption.encrypt(data)
    end
  end

  defp write_to_disk(data, filename, storage_path) do
    Path.join(storage_path, filename)
    |> File.write!(data)
  end

  defp default_storage_path, do: config(:path)
  defp skip_compression?, do: config(:skip_compression?)
  defp skip_encryption?, do: config(:skip_encryption?)
end
