defmodule Perspective.LocalFileNotFound do
  defexception filename: "", storage_path: ""

  def exception(filename, storage_path) do
    %__MODULE__{
      filename: filename,
      storage_path: storage_path
    }
  end

  def message(%{filename: filename, storage_path: storage_path}) do
    "The file (#{Path.join(storage_path, filename)}) could not be found"
  end
end
