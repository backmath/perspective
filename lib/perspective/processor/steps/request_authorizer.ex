defmodule Perspective.Processor.RequestAuthorizer do
  def authorize(request) do
    case Perspective.ActionRequest.RequestAuthorizer.authorize(request) do
      true -> request
      :ok -> request
      false -> raise(Perspective.Unauthorized, errors: [], request: request)
      {:error, error} -> raise(Perspective.Unauthorized, errors: [error], request: request)
      _ -> raise(Perspective.Unauthorized, errors: [], request: request)
    end
  end
end
