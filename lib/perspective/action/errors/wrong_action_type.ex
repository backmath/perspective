defmodule Perspective.Action.WrongActionType do
  defexception [:action_type, :expected_type]

  def exception({%action_type{} = _provided_action, expected_type}) do
    %__MODULE__{
      action_type: action_type,
      expected_type: expected_type
    }
  end

  def message(%__MODULE__{action_type: action_type, expected_type: expected_type} = _exception) do
    "You have supplied #{action_type}, but this module only accepts #{expected_type}"
  end
end
