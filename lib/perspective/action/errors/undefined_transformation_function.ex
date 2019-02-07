defmodule Perspective.Action.UndefinedTransformationFunction do
  defexception [:calling_module]

  def exception(calling_module) do
    %__MODULE__{
      calling_module: calling_module
    }
  end

  def message(%__MODULE__{calling_module: calling_module} = _exception) do
    "You have not defined a transformation function for #{calling_module}"
  end
end
