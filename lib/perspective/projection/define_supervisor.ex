defmodule Perspective.Projection.DefineSupervisor do
  def define(broadcasters, module, caller) do
    module_name = Perspective.ProjectionNames.supervisor(module)

    children = endpoint(module) ++ Enum.map(broadcasters, fn {_, broadcaster} -> broadcaster end)

    definition =
      quote do
        use Perspective.Supervisor

        children do
          unquote(children)
        end
      end

    Module.create(module_name, definition, Macro.Env.location(caller))

    module_name
  end

  # Document this change
  defp endpoint(module) do
    case Mix.env() do
      :test -> []
      _ -> [Perspective.ProjectionNames.endpoint(module)]
    end
  end
end
