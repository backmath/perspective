defmodule Perspective.Reactor.DefineGenServer do
  def define(module, updateable_events, caller) do
    genserver_name = Module.concat([module, GenServer])
    debouncer_name = Module.concat([module, BackupDebouncer])

    definition =
      quote do
        use GenServer

        def handle_call(:state, _from, state) do
          {:reply, state, state}
        end

        def handle_call(:reset, _from, state) do
          state = Perspective.Reactor.BuildReactorState.build_from_scratch(unquote(module))

          {:reply, :ok, state}
        end

        def handle_call(event, _from, state) do
          new_state = generate_and_backup_new_state(event, state)
          {:reply, new_state, new_state}
        end

        def handle_cast(event, state) do
          new_state = generate_and_backup_new_state(event, state)
          {:noreply, new_state}
        end

        def handle_info(event, state) do
          new_state = generate_and_backup_new_state(event, state)
          {:noreply, new_state}
        end

        def start_link(_opts) do
          GenServer.start_link(unquote(genserver_name), :ok, name: unquote(genserver_name))
        end

        def terminate(reason, state) do
          IO.inspect(reason, label: "genserver terminated")
        end

        def init(_ok) do
          subscribe_to(unquote(updateable_events))

          configure_backup_debouncer()

          {:ok, build_initial_state()}
        end

        defp generate_and_backup_new_state(event, %Perspective.Reactor.State{data: data} = state) do
          updated_data = unquote(module).update(event, data)

          new_state = Perspective.Reactor.State.update(state, updated_data, event)

          case save_backup() do
            :ok -> new_state
          end
        end

        defp subscribe_to(updateable_events) do
          Enum.each(updateable_events, fn event ->
            Perspective.Notifications.subscribe(struct(event, []))
          end)
        end

        defp build_initial_state do
          Perspective.Reactor.BuildReactorState.build_from_backup(unquote(module))
        end

        defp save_backup do
          Perspective.Debouncer.execute(unquote(debouncer_name), :backup_state)
        end

        defp configure_backup_debouncer do
          Perspective.Debouncer.register(unquote(debouncer_name), :backup_state, fn ->
            state = unquote(genserver_name).state()
            Perspective.Reactor.BackupState.save_state(unquote(module), state)
          end)
        end

        ### MOVE LATER

        def state do
          GenServer.call(unquote(genserver_name), :state)
        end

        def data do
          Map.get(state(), :data)
        end

        def send(event) do
          GenServer.call(unquote(genserver_name), event)
        end

        def reset do
          GenServer.call(unquote(genserver_name), :reset)
        end
      end

    Module.create(genserver_name, definition, Macro.Env.location(caller))
  end
end
