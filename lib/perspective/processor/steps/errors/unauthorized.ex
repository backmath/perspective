defmodule Perspective.Unauthorized do
  defexception errors: [], request: nil

  def exception(errors: errors, request: request) do
    %__MODULE__{errors: errors, request: request}
  end

  def message(%{request: %request_type{}}) do
    "You are unauthorized to make this request (#{request_type})"
  end
end
