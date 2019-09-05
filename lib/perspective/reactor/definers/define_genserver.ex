defmodule Perspective.Reactor.DefineGenServer do
  def define(module, updateable_events, caller) do
    genserver_name = Perspective.Reactor.Names.server(module)

    definition =
      quote do
        use Perspective.GenServer

        initial_state do
          subscribe_to(unquote(updateable_events))
          build_initial_state()
        end

        def handle_call(:reset, _from, state) do
          state = Perspective.Reactor.BuildReactorState.build_from_scratch(unquote(module))

          {:reply, :ok, state}
        end

        def handle_call(event, _from, state) do
          new_state = generate_updated_state(event, state)
          {:reply, new_state, new_state}
        end

        def handle_cast(event, state) do
          new_state = generate_updated_state(event, state)
          {:noreply, new_state}
        end

        def handle_info(event, state) do
          new_state = generate_updated_state(event, state)
          {:noreply, new_state}
        end

        def terminate(reason, state) do
          IO.inspect(reason, label: "genserver terminated")
        end

        defp generate_updated_state(event, %Perspective.Reactor.State{data: data} = state) do
          updated_data = unquote(module).update(event, data)

          Perspective.Reactor.State.update(state, updated_data, event)
        end

        defp subscribe_to(updateable_events) do
          Enum.each(updateable_events, fn event ->
            Perspective.Notifications.subscribe(struct(event, []))
          end)
        end

        defp build_initial_state do
          Perspective.Reactor.BuildReactorState.build_from_backup(unquote(module))
        end

        ### MOVE LATER

        def state do
          call(:state)
        end

        def data do
          Map.get(state(), :data)
        end

        def send(event) do
          call(event)
        end
      end

    Module.create(genserver_name, definition, Macro.Env.location(caller))
  end
end
