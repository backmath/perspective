defmodule Perspective.Authentication.UsernameNotFound do
  defexception username: ""

  def exception(username) do
    %__MODULE__{
      username: username
    }
  end

  def message(%{username: username}) do
    "The username (#{username}) could not be found"
  end
end
