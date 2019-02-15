defmodule Perspective.ModuleRegistry do
  defmacro __using__(_) do
    quote do
      import Perspective.ModuleRegistry
    end
  end

  defmacro register_module(name) do
    module =
      Perspective.ModuleRegistry
      |> Module.concat(Macro.expand(name, __ENV__))
      |> Module.concat(__CALLER__.module)

    quote do
      defmodule unquote(module) do
      end
    end
  end

  def list(name) do
    module_prefix =
      Module.concat(Perspective.ModuleRegistry, name)
      |> to_string

    applications = :application.loaded_applications()

    Enum.reduce(applications, [], fn {app, _desc, _version}, acc ->
      {:ok, modules} = :application.get_key(app, :modules)

      new_modules =
        modules
        |> Enum.filter(fn module ->
          String.starts_with?(to_string(module), module_prefix)
        end)
        |> Enum.map(fn module ->
          module
          |> to_string()
          |> String.replace(~r/#{module_prefix}/, "Elixir")
          |> String.to_existing_atom()
        end)

      new_modules ++ acc
    end)
  end
end
