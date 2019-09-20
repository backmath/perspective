defmodule Perspective.Core.DomainPool do
  use Perspective.GenServer

  initial_state do
    %{}
  end

  def get(node_id) do
    call({:get, node_id})
  end

  def get!(node_id) do
    case get(node_id) do
      {:ok, node} -> node
      {:error, error} -> raise error
    end
  end

  def put(node) do
    call({:put, node})
    |> case do
      :ok -> {:ok, node}
    end
  end

  def put!(node_id) do
    case put(node_id) do
      {:ok, node} -> node
    end
  end

  def delete(node) do
    call({:delete, node})
    |> case do
      :ok -> {:ok, nil}
    end
  end

  def handle_call({:get, node_id}, _from, state) do
    result =
      Map.get(state, node_id)
      |> case do
        nil -> {:error, %Perspective.Core.DomainPool.NodeNotFound{id: node_id}}
        node -> {:ok, node}
      end

    {:reply, result, state}
  end

  def handle_call({:put, node}, _from, state) do
    new_state = Map.put(state, node.id, node)
    {:reply, :ok, new_state}
  end

  def handle_call({:delete, node}, _from, state) do
    new_state = Map.delete(state, node.id)
    {:reply, :ok, new_state}
  end
end