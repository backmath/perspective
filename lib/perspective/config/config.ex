defmodule Perspective.Config do
  defmacro __using__(key) do
    module = __CALLER__.module
    config_key = config_key(key, __CALLER__)
    set_application_configuration(module, config_key)

    quote do
      def config(key) do
        @application_configuration
        |> fetch(key)
      end

      defp fetch(keywords, key) do
        try do
          Keyword.fetch!(keywords, key)
        rescue
          KeyError ->
            raise Perspective.Config.MissingOptionKey,
              module: unquote(module),
              config_key: unquote(config_key),
              key: key
        end
      end
    end
  end

  defp set_application_configuration(module, config_key) do
    try do
      config = Application.fetch_env!(:perspective, config_key)
      Module.put_attribute(module, :application_configuration, config)
    rescue
      ArgumentError -> raise Perspective.Config.MissingConfigurationKey, module: module, config_key: config_key
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
