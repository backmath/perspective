defmodule Perspective.Authentication.TokenError do
  defexception error: ""

  def exception(error) do
    %__MODULE__{
      error: error
    }
  end

  def message(_) do
    "The authentication token is invalid."
  end
end
