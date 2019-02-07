defmodule Perspective.Action.InvalidAction do
  defexception [action: %{}, errors: []]

  def exception({action, errors}) do
    %__MODULE__{
      action: action,
      errors: errors
    }
  end

  def message(exception) do
    %action{} = exception.action
    "The action (#{action}) is invalid (to enumerate later)."
  end
end
