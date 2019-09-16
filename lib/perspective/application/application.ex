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
        Perspective.ServerReferences.store_process_references(__MODULE__, app_id: app_id())

        opts = [strategy: :one_for_one, name: name()]
        Supervisor.start_link(all_children(), opts)
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

      defp app_id do
        Process.get(:app_id, config(:app_id))
      end

      defp name do
        Process.get(:name, config(:app_id))
      end
    end
  end

  defmacro children(do: block) do
    quote do
      def children, do: unquote(block)
    end
  end
end
