defmodule Perspective.Action do
  defmacro transform(agent, do: block) do
    type = __CALLER__.module()

    quote do
      def do_transform(%unquote(type){} = unquote(agent)), do: unquote(block)

      def do_transform(%wrong_type{} = action) do
        raise(Perspective.Action.WrongActionTypeError, [wrong_type, __MODULE__])
      end
    end
  end

  defmacro __using__(_opts) do
    calling_module = __CALLER__.module

    quote do
      import Perspective.Action

      def do_transform(_action) do
        raise Perspective.Action.UndefinedTransformationFunction, unquote(calling_module)
      end

      defoverridable do_transform: 1
      # @callback do_transform(any) :: any
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

    def exception(value) do
      %__MODULE__{
        message: "You have not defined a transformation function for #{value}"
      }
    end
  end
end
