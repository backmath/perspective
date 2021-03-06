defmodule Perspective.Processor.SyntaxValidator do
  def validate(request) do
    case Perspective.ActionRequest.SyntaxValidator.validate_syntax(request) do
      true -> request
      :ok -> request
      nil -> request
      [] -> request
      errors -> raise(Perspective.InvalidSyntax, errors: errors, request: request)
    end
  end
end
