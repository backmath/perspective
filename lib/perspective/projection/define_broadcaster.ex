defmodule Perspective.Projection.DefineBroadcaster do
  def define(path, reactor, caller) do
    genserver_name = Module.concat(reactor, ProjectionBroadcaster)
    endpoint = Module.concat(caller.module, PhoenixEndpoint)

    definition =
      quote do
        use Perspective.GenServer

        initial_state do
          subscribe_to_reactor_updates()

          :ok
        end

        def handle_info(event, state) do
          broadcast_to_subscribers(event)
          {:noreply, state}
        end

        defp subscribe_to_reactor_updates do
          Perspective.Notifications.subscribe(
            %Perspective.Reactor.StateUpdated{},
            unquote(reactor)
          )
        end

        defp broadcast_to_subscribers(event) do
          data = unquote(reactor).data()
          unquote(endpoint).broadcast!(unquote(path), "update", data)
        end
      end

    Module.create(genserver_name, definition, Macro.Env.location(caller))
  end
end