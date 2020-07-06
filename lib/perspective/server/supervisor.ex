defmodule Perspective.Supervisor do
  defmacro __using__(_) do
    quote do
      use Supervisor
      use Perspective.IdentifierMacro
      import Perspective.Supervisor

      @children :nothing

      def start_link(options) when is_list(options) or is_map(options) do
        module = unquote(__CALLER__.module)

        name = module.name(options)

        Supervisor.start_link(module, options, name: name)
      end

      def start_link() do
        validate_children()
        start_link([])
      end

      def start_link(_) do
        validate_children()
        start_link([])
      end

      def init(args) do
        Perspective.GenServer.ProcessIdentifiers.store(module(), args)

        children()
        |> Perspective.ChildrenSpecs.set_app_id(app_id(args))
        |> Supervisor.init(strategy: :one_for_one)
      end

      defp module do
        unquote(__CALLER__.module)
      end

      defp validate_children do
        case children() do
          value when is_list(value) -> :ok
          value -> raise Perspective.Supervisor.IncorrectConfiguration, "expected a list of tuples, received #{value}"
        end
      end
    end
  end

  defmacro children(do: block) do
    quote do
      def children, do: unquote(block)
    end
  end
end
