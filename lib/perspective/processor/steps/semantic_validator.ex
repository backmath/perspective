defmodule Perspective.Processor.SemanticValidator do
  def validate(request) do
    case Perspective.ActionRequest.SemanticValidator.validate_semantics(request) do
      [] -> request
      errors -> raise(Perspective.InvalidSemantics, errors: errors, request: request)
    end
  end
end
