defmodule Perspective.AnonymousUserRejected do
  defexception []

  def message(_) do
    "The request disallows anonymous users"
  end
end

defmodule Perspective.ActionRequest.RejectAnonymousUsers do
  defmacro __using__(_options) do
    quote do
      import Perspective.AuthorizeRequest

      Perspective.AuthorizeRequest.authorize %{actor_id: ""}, 0 do
        {:error, %Perspective.AnonymousUserRejected{}}
      end

      Perspective.AuthorizeRequest.authorize %{actor_id: nil}, 0 do
        {:error, %Perspective.AnonymousUserRejected{}}
      end

      Perspective.AuthorizeRequest.authorize %{actor_id: "user/anonymous"}, 0 do
        {:error, %Perspective.AnonymousUserRejected{}}
      end

      Perspective.AuthorizeRequest.authorize %{}, 100 do
        {:error, %Perspective.Unauthorized{}}
      end
    end
  end
end
