defmodule Perspective.NodePool do
  defmacro __using__(_) do
    definition = definition(__CALLER__.module)

    quote bind_quoted: [definition: definition] do
      # @before_compile Perspective.NodePool
      definition
    end
  end

  def definition(calling_module) do
    quote bind_quoted: [calling_module: calling_module] do
      use Perspective.GenServer
      use Perspective.NodePoolMacros.Index

      import Perspective.NodePool

      initial_state do
        %{}
      end

      def get(node_id) do
        call({:get, node_id})
      end

      def put(node) do
        call({:put, node})
      end

      def delete(node_id) do
        call({:delete, node_id})
      end

      def handle_call({:get, node_id}, _from, state) do
        result =
          Map.get(state, node_id)
          |> case do
            nil ->
              {:error, %Perspective.NodePool.NodeNotFound{search: [:id, node_id], node_pool: unquote(calling_module)}}

            node ->
              node
          end

        {:reply, result, state}
      end

      def handle_call({:put, node}, _from, state) do
        new_state =
          Map.put(state, node.id, node)
          |> index_node(node)

        {:reply, :ok, new_state}
      end

      def handle_call({:delete, node_id}, _from, state) do
        updated_state =
          case pop_in(state, [node_id]) do
            {nil, new_state} -> new_state
            {node, new_state} -> unindex_node(new_state, node)
          end

        {:reply, :ok, updated_state}
      end

      defp index_node(state, node) do
        old_node = Map.get(state, node.id)
        the_index = Map.get(state, :indexes, %{})

        updated_index =
          Enum.map(indexes(), fn index_key ->
            old_indexing_value = index({index_key, old_node})
            new_indexing_value = index({index_key, node})
            {index_key, old_indexing_value, new_indexing_value}
          end)
          |> Enum.reduce(the_index, fn {indexing_key, old_indexing_value, new_indexing_value}, acc_index ->
            updated_index =
              Map.get(acc_index, indexing_key, %{})
              |> Map.delete(old_indexing_value)
              |> Map.put(new_indexing_value, node.id)
              |> Map.delete(nil)

            Map.put(acc_index, indexing_key, updated_index)
          end)

        Map.put(state, :indexes, updated_index)
      end

      defp unindex_node(state, old_node) do
        the_index = Map.get(state, :indexes, %{})

        updated_index =
          Enum.reduce(indexes(), the_index, fn index_key, updated_index ->
            indexing_value = index({index_key, old_node})

            {_, state} = pop_in(updated_index, [index_key, indexing_value])

            state
          end)

        Map.put(state, :indexes, updated_index)
      end
    end
  end
end
