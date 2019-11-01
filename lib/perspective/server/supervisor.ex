defmodule Perspective.Supervisor do
  defmacro __using__(_) do
    quote do
      use Supervisor
      import Perspective.Supervisor
      @before_compile Perspective.Supervisor
      @children :nothing

      def start_link(options) when is_list(options) or is_map(options) do
        module = unquote(__CALLER__.module)

        name = Perspective.ServerName.name(module, options)

        Supervisor.start_link(module, options, name: name)
      end

      def start_link() do
        start_link([])
      end

      def start_link(_) do
        start_link([])
      end

      def init(args) do
        Perspective.ServerReferences.store_process_references(unquote(__CALLER__.module), args)

        children()
        |> Perspective.ChildrenSpecs.set_app_id(app_id(args))
        |> Supervisor.init(strategy: :one_for_one)
      end

      defp app_id(args) when is_list(args) do
        Keyword.get(args, :app_id, nil)
      end

      defp app_id(%{app_id: app_id}) do
        app_id
      end

      defp app_id(_non_list) do
        nil
      end
    end
  end

  defmacro children(do: block) do
    quote do
      @children unquote(block)
      def children, do: unquote(block)
    end
  end

  defmacro __before_compile__(_) do
    Module.get_attribute(__CALLER__.module, :children)
    |> validate_children()
  end

  defp validate_children(children) do
    case children do
      value when is_list(value) -> :ok
      value -> raise Perspective.Supervisor.IncorrectConfiguration, "expected a list of tuples, received #{value}"
    end
  end
end
