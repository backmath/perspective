defmodule Perspective.Reactor.BuildReactorState do
  def build_from_scratch(reactor_name) do
    run_initializer(reactor_name)
    |> update_with_event_chain(reactor_name)
  end

  def build_from_backup(reactor_name) do
    load_from_backup_or_run_initialize(reactor_name)
    |> update_with_event_chain(reactor_name)
  end

  defp load_from_backup_or_run_initialize(reactor_name) do
    try do
      Perspective.Reactor.BackupState.load_state(reactor_name)
    rescue
      Perspective.Reactor.BackupStateMissing -> run_initializer(reactor_name)
    end
  end

  defp update_with_event_chain(%{last_event_processed: last_event_processed} = reactor_state, reactor_name) do
    Perspective.EventChain.since(last_event_processed)
    |> Stream.filter(fn %event_type{} -> Enum.member?(reactor_name.updateable_events, event_type) end)
    |> Enum.reduce(reactor_state, fn event, state ->
      module = Perspective.Reactor.Names.server(reactor_name)
      module.generate_updated_state(event, state)
    end)
  end

  defp run_initializer(reactor_name) do
    data = reactor_name.initial_state()
    Perspective.Reactor.State.from(last_event_processed: nil, data: data)
  end
end
