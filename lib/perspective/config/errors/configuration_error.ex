defmodule Perspective.ConfigurationError do
  defexception [:module, :key]

  def exception(module: module, key: key) do
    %__MODULE__{
      module: module,
      key: key
    }
  end

  def message(%{module: module, key: key}) do
    """
    Configuration lookup failed

    The module #{strip_elixir(module)} using Perspective.Config, but no such key exists.

    To fix, set the following in your configuration:

    config :perspective, #{strip_elixir(key)}, data: :data
    """
  end

  defp strip_elixir(module) do
    String.replace("#{module}", ~r/^Elixir./, "")
  end
end
