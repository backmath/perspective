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

      defmodule Updated do
        defstruct [:data]
      end

      def find(id) do
        Map.get(data(), id, {:error, %NotFound{id: id}})
        |> transform_index()
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

      broadcast(event, %{data: data}, _old_state) do
        key = index_key(event)

        data =
          Map.get(data, key, initial_value())
          |> transform_index()

        broadcast_event = %Updated{data: data}

        Perspective.Notifications.emit(broadcast_event, key)
      end

      def transform_index(error = {:error, _}) do
        error
      end

      def transform_index(data) do
        data
      end

      defoverridable(transform_index: 1)
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

  defmacro transform_index(data, do: block) do
    quote do
      def transform_index(unquote(data)), do: unquote(block)
    end
  end

  defmacro __before_compile__(_env) do
  end
end
