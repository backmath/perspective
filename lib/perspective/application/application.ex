defmodule Perspective.Application do
  defmacro __using__(_) do
    quote do
      import Perspective.AppID
      import Perspective.Application
      use Perspective.Config, Perspective.Application
      use Perspective.IdentifierMacro
      use Application

      def start do
        start(app_id: configured_app_id())
      end

      def start(_type, _args) do
        start(app_id: configured_app_id())
      end

      def start(opts) when is_list(opts) do
        start(%{app_id: Keyword.get(opts, :app_id)})
      end

      def start(%{app_id: app_id}) do
        Perspective.GenServer.ProcessIdentifiers.store(__MODULE__, app_id: app_id)

        Supervisor.start_link(all_children(), opts())
      end

      def all_children do
        [
          Perspective.Application.Supervisor
        ]
        |> Enum.concat(children())
        |> Perspective.ChildrenSpecs.set_app_id(configured_app_id())
      end

      def children do
        []
      end

      defoverridable(children: 0)

      defp configured_app_id do
        Process.get(:app_id, config(:app_id))
      end

      defp configured_name do
        {:global, configured_app_id()}
      end

      defp opts do
        [strategy: :one_for_one, name: configured_name()]
      end
    end
  end

  defmacro children(do: block) do
    quote do
      def children, do: unquote(block)
    end
  end
end
