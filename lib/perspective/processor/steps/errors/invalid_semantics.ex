defmodule Perspective.InvalidSemantics do
  defexception [:errors, :request]

  def exception(errors: errors, request: request) do
    %__MODULE__{errors: errors, request: request}
  end

  def message(%{request: %request_type{}}) do
    "The request (#{request_type}) has invalid semantics"
  end
end
