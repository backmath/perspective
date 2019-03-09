defmodule Perspective.Action do
  alias Perspective.Action.{WrongActionType, UndefinedTransformationFunction}

  defmacro transform(agent, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def transform(%unquote(calling_module){} = unquote(agent)), do: attach_metadata(unquote(block))

      defimpl Perspective.ActionTransformer, for: unquote(calling_module) do
        def transform(%unquote(calling_module){} = unquote(agent)), do: attach_metadata(unquote(block))
      end

      def transform(%wrong_type{} = action) do
        raise(WrongActionType, {action, unquote(calling_module)})
      end
    end
  end

  def attach_metadata(event) do
    event
    |> Map.put(:domain_event_id, UUID.uuid4())
    |> Map.put(:domain_event_date, DateTime.utc_now() |> DateTime.to_iso8601())
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
