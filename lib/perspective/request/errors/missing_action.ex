defmodule Perspective.Request.MissingAction do
  defexception action_name: ""

  def exception(action_name) do
    %__MODULE__{
      action_name: action_name
    }
  end

  def message(%__MODULE__{action_name: action_name}) do
    "The action (#{action_name}) could not be found"
  end
end
