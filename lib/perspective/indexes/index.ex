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

      def find(id) do
        Map.get(data(), id, nil)
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
