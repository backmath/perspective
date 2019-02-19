defmodule Perspective.Projection.InitialStateUndefined do
  defexception [:module]

  def exception(module) do
    %__MODULE__{
      module: module
    }
  end

  def message(%__MODULE__{module: module} = _excpetion) do
    "The module #{module} is a Perspective.Projection, but it does not define initial_state"
  end
end
