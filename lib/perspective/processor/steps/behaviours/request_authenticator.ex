defmodule Perspective.RequestAuthenticator do
  @callback authenticate(map(), any()) :: map() | {:error, any()}
end
