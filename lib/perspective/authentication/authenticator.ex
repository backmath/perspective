defmodule Perspective.Authenticator do
  @callback authenticate_request(map(), any()) :: map() | {:error, any()}
end
