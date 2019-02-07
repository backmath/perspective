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

  defmacro defaction(keys) when is_list(keys) do

    unless Keyword.keyword?(keys) do
      values = keys
        |> Enum.map(&(":#{&1}"))
        |> Enum.join(", ")
        |> (fn string ->
          "[#{string}]"
        end).()

      raise ArgumentError, "defaction expects a keyword list, but was provided: #{values}"
    end

    key_set = [actor: "", request: "", request_date: "", references: Macro.escape(%{})] |> Keyword.merge(keys)

    quote do
      defstruct unquote(key_set)
    end
  end

  defmacro __using__(_opts) do
    calling_module = __CALLER__.module

    quote do
      import Perspective.Action
      use Vex.Struct

      def transform(_action) do
        raise UndefinedTransformationFunction, unquote(calling_module)
      end

      defoverridable transform: 1
    end
  end
end
