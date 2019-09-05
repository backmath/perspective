defmodule Perspective.Reactor.DefineSupervisor do
  def define(module, caller) do
    supervisor_name = Perspective.Reactor.Names.supervisor(module)
    genserver_name = Perspective.Reactor.Names.server(module)

    definition =
      quote do
        use Perspective.Supervisor

        children do
          [
            {unquote(genserver_name)}
          ]
        end
      end

    Module.create(supervisor_name, definition, Macro.Env.location(caller))
  end
end
