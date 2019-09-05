defmodule Perspective.EventChain.PageWriter do
  use Perspective.GenServer

  initial_state do
    check_for_events()

    :ok
  end

  defmodule Debouncer do
    use Perspective.Debouncer

    execute do
      Perspective.EventChain.MoveEventsFromBufferToCurrentPage.run()

      Perspective.EventChain.SaveCurrentPage.run()

      if Perspective.EventChain.CurrentPage.is_full?() do
        Perspective.EventChain.StartANewPage.run()
      end
    end
  end

  def save() do
    Debouncer.execute()
  end

  def check_for_events do
    Perspective.ServerName.name(__MODULE__)
    |> GenServer.whereis()
    |> Process.send_after(:check_for_events, 50)
  end

  def handle_info(:check_for_events, _state) do
    if Perspective.EventChain.PageBuffer.has_events?() do
      save()
    end

    check_for_events()

    {:noreply, []}
  end
end
