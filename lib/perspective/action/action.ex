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

      def transform(_action) do
        raise UndefinedTransformationFunction, unquote(calling_module)
      end

      defoverridable transform: 1
    end
  end
end
