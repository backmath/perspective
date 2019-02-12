defmodule Perspective.Config do
  defmacro __using__(_) do
    calling_module = __CALLER__.module

    quote do
      def config(key, default \\ nil) do
        Application.get_env(:perspective, unquote(calling_module))
        |> Keyword.get(key, default)
      end
    end
  end
end
