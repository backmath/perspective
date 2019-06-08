defmodule Perspective.Reactor.DefineSupervisor do
  def define(module, caller) do
    supervisor_name = Module.concat([module, Supervisor])
    genserver_name = Module.concat([module, GenServer])
    debouncer_name = Module.concat([module, BackupDebouncer])

    definition =
      quote do
        use Supervisor

        def start_link(_opts \\ nil) do
          Supervisor.start_link(unquote(supervisor_name), :ok, name: unquote(supervisor_name))
        end

        def init(_args) do
          children = [
            {Perspective.Debouncer, [name: unquote(debouncer_name)]},
            {unquote(genserver_name), [name: unquote(genserver_name)]}
          ]

          Supervisor.init(children, strategy: :one_for_one)
        end

        def reboot do
          Supervisor.terminate_child(unquote(supervisor_name), unquote(genserver_name))
          Supervisor.restart_child(unquote(supervisor_name), unquote(genserver_name))
        end
      end

    Module.create(supervisor_name, definition, Macro.Env.location(caller))
  end
end
