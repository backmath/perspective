defmodule Perspective.NodePool do
  defmacro __using__(_) do
    calling_module = __CALLER__.module

    quote do
      use Perspective.GenServer

      initial_state do
        %{}
      end

      def get(node_id) do
        call({:get, node_id})
      end

      def get!(node_id) do
        case get(node_id) do
          {:error, error} -> raise error
          node -> node
        end
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
            nil -> {:error, %Perspective.NodePool.NodeNotFound{id: node_id, node_pool: unquote(calling_module)}}
            node -> node
          end

        {:reply, result, state}
      end

      def handle_call({:put, node}, _from, state) do
        new_state = Map.put(state, node.id, node)
        {:reply, :ok, new_state}
      end

      def handle_call({:delete, node_id}, _from, state) do
        new_state = Map.delete(state, node_id)
        {:reply, :ok, new_state}
      end
    end
  end
end
