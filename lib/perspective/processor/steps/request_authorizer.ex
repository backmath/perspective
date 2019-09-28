defmodule Perspective.Processor.RequestAuthorizer do
  def authorize(request) do
    case Perspective.ActionRequest.RequestAuthorizer.authorize_request(request) do
      true -> request
      [] -> request
      {:error, error} -> raise(Perspective.Unauthorized, errors: [error], request: request)
      errors -> raise(Perspective.Unauthorized, errors: errors, request: request)
    end
  end
end
