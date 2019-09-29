defmodule Perspective.Config.MissingConfigurationKey do
  defexception [:module, :config_key]

  def exception(module: module, config_key: config_key) do
    %__MODULE__{
      module: module,
      config_key: config_key
    }
  end

  def message(%{module: module, config_key: config_key}) do
    """
    Missing Configuration Key

    The module #{strip_elixir(module)} uses Perspective.Config, but no such key was found in configuration files.

    To fix, set the following in your configuration:

    config :perspective, #{strip_elixir(config_key)},
      some: :value
    """
  end

  defp strip_elixir(module) do
    String.replace("#{module}", ~r/^Elixir./, "")
  end
end
