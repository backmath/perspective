defmodule Perspective.Socket do
  defmacro __using__(_) do
    quote do
      use Phoenix.Socket
      import Perspective.Socket
    end
  end

  defmacro projection(module, opts \\ []) do
    {path, channel, _reactor} = Macro.expand(module, __ENV__).projection_spec

    quote do
      channel(unquote(path), unquote(channel), unquote(opts))
    end
  end

  defp tear_alias({:__aliases__, meta, [h | t]}) do
    alias = {:__aliases__, meta, [h]}

    quote do
      Module.concat([unquote(alias) | unquote(t)])
    end
  end

  defp tear_alias(other), do: other
end
