defmodule Perspective.Authentication.PasswordChallengeFailed do
  defexception username: ""

  def exception(username) do
    %__MODULE__{
      username: username
    }
  end

  def message(%{username: username}) do
    "The password challenge for (#{username}) failed."
  end
end
