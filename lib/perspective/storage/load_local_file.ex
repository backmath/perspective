defmodule Perspective.LoadLocalFile do
  def load(file_path) do
    try do
      read_from_disk(file_path)
      |> decrypt()
      |> decompress()
    rescue
      File.Error -> {:error, Perspective.LocalFileNotFound.exception(file_path)}
    end
  end

  def load!(file_path) do
    case load(file_path) do
      {:error, error} -> raise error
      file -> file
    end
  end

  defp read_from_disk(file_path) do
    File.read!(file_path)
  end

  defp decrypt(data) do
    try do
      Perspective.Encryption.decrypt(data)
    rescue
      Perspective.NonDecryptableData -> data
    end
  end

  defp decompress(data) do
    try do
      :zlib.gunzip(data)
    rescue
      ErlangError -> data
    end
  end
end
