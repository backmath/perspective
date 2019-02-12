defmodule Perspective.DomainPool.NodeNotFound do
  defexception [:id]

  def exception(value) do
    %__MODULE__{
      id: value
    }
  end

  def message(%__MODULE__{} = exception) do
    "The domain node (#{exception.id}) could not be found"
  end
end
