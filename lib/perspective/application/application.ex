defmodule Perspective.Application do
  defmacro __using__(_) do
    quote do
      import Perspective.Application
      use Perspective.Config, Perspective.Application
      use Application

      def start do
        start(nil, nil)
      end

      def start(_type, _args) do
        opts = [strategy: :one_for_one, name: app_name()]
        Supervisor.start_link(all_children(), opts)
      end

      def app_id do
        # Needs a test
        Process.get(:app_id, config(:app_id))
      end

      def app_name do
        Perspective.ServerName.name(__MODULE__)
      end

      def all_children do
        [
          Perspective.Application.Supervisor
        ]
        |> Enum.concat(children())
        |> Perspective.ChildrenSpecs.set_app_id(app_id())
      end

      def children do
        []
      end

      defoverridable(children: 0)
    end
  end

  defmacro children(do: block) do
    quote do
      def children, do: unquote(block)
    end
  end
end
