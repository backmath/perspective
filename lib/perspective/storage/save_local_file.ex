defmodule Perspective.SaveLocalFile do
  use Perspective.Config, Perspective.LocalFileStorage

  def save(data, file_path) do
    data
    |> compress()
    |> encrypt()
    |> write_to_disk(file_path)
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

  defp write_to_disk(data, file_path) do
    try do
      File.write!(file_path, data)
    rescue
      error in File.Error ->
        if error.reason == :enoent do
          ensure_directory_exists(file_path)
          write_to_disk(data, file_path)
        else
          raise error
        end
    end
  end

  defp skip_compression?, do: config(:skip_compression?)
  defp skip_encryption?, do: config(:skip_encryption?)

  defp ensure_directory_exists(file_path) do
    file_path
    |> Path.dirname()
    |> File.mkdir_p!()
  end
end
