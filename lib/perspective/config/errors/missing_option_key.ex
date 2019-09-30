defmodule Perspective.Config.MissingOptionKey do
  defexception [:module, :config_key, :key]
  import Perspective.StripElixir

  def exception(module: module, config_key: config_key, key: key) do
    %__MODULE__{
      module: module,
      config_key: config_key,
      key: key
    }
  end

  def message(%{module: module, config_key: config_key, key: key}) do
    """
    Missing Option Key

    The module #{strip_elixir(module)} has called config(#{key}),
    but no such option has been configured.

    To fix, set the following in your configuration:

    config :perspective, #{strip_elixir(config_key)},
      #{key}: :data
    """
  end
end
