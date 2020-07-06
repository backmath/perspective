defmodule Perspective.IdentifierMacro do
  defmacro __using__(_) do
    quote do
      import Perspective.AppID
      import Perspective.IdentifierMacro

      def path do
        unquote(__CALLER__.module)
        |> Perspective.StripElixir.strip_elixir()
      end

      def name do
        {:global, uri()}
      end

      def uri do
        [app_id(), unquote(__CALLER__.module).path()]
        |> Path.join()
      end

      def path(_state) do
        path()
      end

      def name(_state) do
        name()
      end

      def uri(_state) do
        uri()
      end

      defoverridable(path: 0, path: 1, name: 0, name: 1, uri: 0, uri: 1)
    end
  end

  defmacro path(state, do: block) do
    quote do
      import Perspective.AppID

      def path(unquote(state)) do
        unquote(block)
      end

      def uri(unquote(state)) do
        [app_id(), unquote(__CALLER__.module).path(unquote(state))]
        |> Path.join()
      end

      def name(unquote(state)) do
        {:global, uri(unquote(state))}
      end
    end
  end
end
