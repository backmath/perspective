defmodule Perspective.LocalFileNotFound do
  defexception file_path: ""

  def exception(file_path) do
    %__MODULE__{
      file_path: file_path
    }
  end

  def message(%{file_path: file_path}) do
    "The file (#{file_path}) could not be found"
  end
end
