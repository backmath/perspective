defmodule Perspective.Config do
  defmacro __using__(key) do
    module = __CALLER__.module
    config_key = config_key(key, __CALLER__)

    quote do
      def config(key) do
        try do
          Application.fetch_env!(:perspective, unquote(config_key))
          |> Keyword.fetch!(key)
        rescue
          ArgumentError ->
            raise Perspective.Config.MissingOptionKey,
              module: unquote(module),
              config_key: unquote(config_key),
              key: key

          KeyError ->
            raise Perspective.Config.MissingOptionKey,
              module: unquote(module),
              config_key: unquote(config_key),
              key: key
        end
      end
    end
  end

  defp config_key(key, caller) do
    optional_key =
      case Macro.expand(key, caller) do
        nil -> nil
        [] -> nil
        atom when is_atom(atom) -> atom
      end

    optional_key || caller.module
  end
end
