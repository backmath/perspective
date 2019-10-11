defmodule Perspective.NodePoolMacros.Index do
  defmacro __using__(_) do
    calling_module = __CALLER__.module

    Module.register_attribute(calling_module, :indexes, accumulate: true)

    quote do
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro index(key, node, do: block) do
    calling_module = __CALLER__.module

    Module.put_attribute(calling_module, :indexes, key)

    quote do
      def index({unquote(key), unquote(node)}), do: unquote(block)

      def find({unquote(key), value}) do
        call({:find, unquote(key), value})
      end

      def handle_call({:find, unquote(key), value}, from, state) do
        node_id = get_in(state, [:indexes, unquote(key), value])

        case get_in(state, [:indexes, unquote(key), value]) do
          nil ->
            {:reply,
             {:error,
              %Perspective.NodePool.NodeNotFound{search: [unquote(key), value], node_pool: unquote(calling_module)}},
             state}

          node_id ->
            handle_call({:get, node_id}, from, state)
        end
      end
    end
  end

  defmacro __before_compile__(_) do
    indexes = Module.get_attribute(__CALLER__.module, :indexes, [])

    quote do
      def indexes, do: unquote(indexes)

      def index({_missing, _node}) do
        nil
      end
    end
  end
end
