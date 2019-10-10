defmodule Perspective.NodePool.NodeNotFound do
  import Perspective.StripElixir

  defexception [:id, :node_pool]

  def exception({id, node_pool}) do
    %__MODULE__{
      id: id,
      node_pool: node_pool
    }
  end

  def message(%__MODULE__{id: id, node_pool: node_pool}) do
    "The domain node (#{id}) could not be found in the pool (#{strip_elixir(node_pool)})"
  end
end
