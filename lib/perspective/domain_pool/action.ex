defmodule Perspective.Action do
  defmacro transform(agent, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def transform(%unquote(calling_module){} = unquote(agent)), do: unquote(block)

      defimpl Perspective.ActionTransformer, for: unquote(calling_module) do
        def transform(%unquote(calling_module){} = unquote(agent)), do: unquote(block)
      end

      def transform(%wrong_type{} = action) do
        raise(Perspective.Action.WrongActionTypeError, [wrong_type, __MODULE__])
      end
    end
  end

  defmacro defaction(keys) when is_list(keys) do
    quote do
      defstruct unquote(keys)
    end
  end

  defmacro __using__(_opts) do
    calling_module = __CALLER__.module

    quote do
      import Perspective.Action
      use Vex.Struct

      def transform(_action) do
        raise Perspective.Action.UndefinedTransformationFunction, unquote(calling_module)
      end

      defoverridable transform: 1
    end
  end

  defmodule WrongActionTypeError do
    defexception [:message]

    def exception([value, calling_module]) do
      %__MODULE__{
        message: "You have supplied #{value}, but this module only accepts #{calling_module}"
      }
    end
  end

  defmodule UndefinedTransformationFunction do
    defexception [:message]

    def exception(calling_module) do
      %__MODULE__{
        message: "You have not defined a transformation function for #{calling_module}"
      }
    end
  end
end
