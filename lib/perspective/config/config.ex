defmodule Perspective.Config do
  defmacro __using__(key) do
    # raise an error with wrong usage
    optional_key =
      case Macro.expand(key, __CALLER__) do
        nil -> nil
        [] -> nil
        atom when is_atom(atom) -> atom
      end

    config_key = optional_key || __CALLER__.module

    quote do
      def config(key, default \\ nil) do
        Application.get_env(:perspective, unquote(config_key))
        |> Keyword.get(key, default)
      end
    end
  end
end
