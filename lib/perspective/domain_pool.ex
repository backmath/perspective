defmodule Perspective.DomainPool do
  use Agent

  def get(node_id) do
    Agent.get(__MODULE__, fn nodes -> Map.get(nodes, node_id) end)
    |> case do
      nil -> {:error, %Perspective.NodeNotFound{id: node_id}}
      node -> {:ok, node}
    end
  end

  def put(node) do
    Agent.update(__MODULE__, fn nodes ->
      Map.put(nodes, node.id, node)
    end)
    |> case do
      :ok -> {:ok, node}
    end
  end

  def delete(node) do
    Agent.update(__MODULE__, fn nodes ->
      Map.delete(nodes, node.id)
    end)
    |> case do
      :ok -> {:ok, nil}
    end
  end

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end
end
