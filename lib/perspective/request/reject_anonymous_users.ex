defmodule Perspective.AnonymousUserRejected do
  defexception []

  def message(_) do
    "The request disallows anonymous users"
  end
end

defmodule Perspective.UnauthorizedUser do
  defexception []

  def message(_) do
    "The user is unauthorized to perform this request"
  end
end

defmodule Perspective.ActionRequest.RejectAnonymousUsers do
  defmacro __using__(_options) do
    quote do
      Perspective.AuthorizeRequest.authorize_request %{actor_id: ""}, 0 do
        {:error, %Perspective.AnonymousUserRejected{}}
      end

      Perspective.AuthorizeRequest.authorize_request %{actor_id: nil}, 0 do
        {:error, %Perspective.AnonymousUserRejected{}}
      end

      Perspective.AuthorizeRequest.authorize_request %{actor_id: "user/anonymous"}, 0 do
        {:error, %Perspective.AnonymousUserRejected{}}
      end

      Perspective.AuthorizeRequest.authorize_request %{}, 100 do
        {:error, %Perspective.UnauthorizedUser{}}
      end
    end
  end
end
