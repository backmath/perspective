defmodule Perspective.NodePool.NodeNotFound do
  import Perspective.StripElixir

  defexception [:search, :node_pool]

  def exception({search, node_pool}) do
    %__MODULE__{
      search: search,
      node_pool: node_pool
    }
  end

  def message(%__MODULE__{search: search, node_pool: node_pool}) do
    "The domain node (#{search}) could not be found in the pool (#{strip_elixir(node_pool)})"
  end
end
