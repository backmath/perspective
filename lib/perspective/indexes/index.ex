defmodule Perspective.Index do
  defmacro __using__(_) do
    quote do
      use Perspective.Reactor
      use Perspective.ModuleRegistry
      import Perspective.Index
      register_module(Perspective.Index)

      @before_compile Perspective.Index

      initial_state do
        %{}
      end

      defmodule NotFound do
        defexception [:id]

        def exception(id) do
          %__MODULE__{id: id}
        end

        def message(%{id: id}) do
          "the index_key #{id} could not be found"
        end
      end

      def find(ids) when is_list(ids) do
        Stream.map(ids, fn id -> find(id) end)
      end

      def find(id) do
        Map.get(data(), id, {:error, %NotFound{id: id}})
      end

      def find!(id) do
        case find(id) do
          {:error, error} -> raise error
          data -> data
        end
      end

      def preprocess_data(event, state) do
        key = index_key(event)
        Map.get(state, key, initial_value())
      end

      def postprocess_data(event, updated_state, original_state) do
        key = index_key(event)
        Map.put(original_state, key, updated_state)
      end
    end
  end

  defmacro id(event, do: block) do
    quote do
      def id(unquote(event)), do: unquote(block)
    end
  end

  defmacro index_key(event, do: block) do
    quote do
      def index_key(unquote(event)), do: unquote(block)
    end
  end

  defmacro initial_value(do: block) do
    quote do
      def initial_value, do: unquote(block)
    end
  end

  defmacro index(event, state, do: block) do
    quote do
      update(unquote(event), unquote(state)) do
        unquote(block)
      end
    end
  end

  defmacro __before_compile__(_env) do
  end
end
