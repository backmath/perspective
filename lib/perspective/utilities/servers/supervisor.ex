defmodule Perspective.Supervisor do
  defmacro __using__(_) do
    quote do
      use Supervisor

      def start_link(options) do
        Supervisor.start_link(unquote(__CALLER__.module), options, name: name(options))
      end

      def init(_) do
        Supervisor.init([], strategy: :one_for_one)
      end

      defoverridable(init: 1)

      defp name(args) do
        Perspective.Server.name(unquote(__CALLER__.module), args)
      end
    end
  end
end
