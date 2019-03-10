defmodule Perspective.Action do
  alias Perspective.Action.{WrongActionType, UndefinedTransformationFunction}

  defmacro transform(agent, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def transform(%unquote(calling_module){} = unquote(agent)), do: unquote(block)

      defimpl Perspective.ActionTransformer, for: unquote(calling_module) do
        def transform(%unquote(calling_module){} = unquote(agent)), do: unquote(block)
      end

      def transform(%wrong_type{} = action) do
        raise(WrongActionType, {action, unquote(calling_module)})
      end
    end
  end

  defmacro __using__(_opts) do
    calling_module = __CALLER__.module

    quote do
      import Perspective.Action
      use Vex.Struct
      use Perspective.ModuleRegistry
      register_module(Perspective.Action)
      # @todo, add a test for module registration
      Module.register_attribute(__MODULE__, :foo, persist: true)

      def transform(_action) do
        raise UndefinedTransformationFunction, unquote(calling_module)
      end

      def skip_authentication? do
        false
      end

      defoverridable transform: 1, skip_authentication?: 0
    end
  end
end
