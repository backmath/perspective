defmodule Perspective.Projection.DefineSupervisor do
  def define(exposures, module, caller) do
    supervisor_name = Module.concat(module, Supervisor)
    endpoint = Module.concat(module, PhoenixEndpoint)

    broadcasters =
      Enum.map(exposures, fn {_path, reactor_name} ->
        Module.concat(reactor_name, ProjectionBroadcaster)
      end)

    children = [endpoint] ++ broadcasters

    definition =
      quote do
        use Perspective.Supervisor

        children do
          unquote(children)
        end
      end

    Module.create(supervisor_name, definition, Macro.Env.location(caller))
  end
end
