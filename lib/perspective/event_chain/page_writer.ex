defmodule Perspective.EventChain.PageWriter do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    check_for_events()
    {:ok, nil}
  end

  def check_for_events do
    Process.send_after(__MODULE__, :check_for_events, 10)
  end

  def handle_info(:check_for_events, _state) do
    if Perspective.EventChain.PageBuffer.has_events?() do
      save()
    end

    check_for_events()

    {:noreply, []}
  end

  def save() do
    Debouncer.call(PageWriterDebouncer, fn ->
      move_events_from_buffer_to_current_page()

      save_current_page()

      if Perspective.EventChain.CurrentPage.is_full?() do
        start_a_new_page()
      end
    end)
  end

  defp move_events_from_buffer_to_current_page do
    Perspective.EventChain.CurrentPage.event_count_remaining()
    |> Perspective.EventChain.PageBuffer.take_out()
    |> Perspective.EventChain.CurrentPage.add()
  end

  defp save_current_page() do
    current_page_path =
      Perspective.EventChain.PageManifest.current_page()
      |> Perspective.StorageConfig.path()

    Perspective.EventChain.CurrentPage.events()
    |> Perspective.Serialize.to_json()
    |> Perspective.SaveLocalFile.save(current_page_path)
  end

  defp start_a_new_page() do
    Perspective.EventChain.PageManifest.add_page()
    Perspective.EventChain.CurrentPage.start_new_page()

    save_current_page()
  end
end
