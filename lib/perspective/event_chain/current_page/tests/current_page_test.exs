defmodule Perspective.EventChain.CurrentPage.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  test "initial load returns a empty events" do
    assert %Perspective.EventChain.CurrentPage.State{events: events} = Perspective.EventChain.CurrentPage.get()

    assert events == []
  end

  test "writing an event" do
    setup_basic_state()

    Perspective.EventChain.CurrentPage.call(:name)
    |> GenServer.whereis()
    |> Process.exit(:early_quit)

    events =
      Perspective.TestSupport.call_repeatedly(fn ->
        case Perspective.EventChain.CurrentPage.get() do
          %{events: []} -> raise "miss"
          %{events: events} -> events
        end
      end)

    assert events == %{"some" => "event"}
  end

  defp setup_basic_state do
    path =
      Perspective.EventChain.PageManifest.current_page()
      |> Perspective.StorageConfig.path()

    %{some: :event}
    |> Perspective.Serialize.to_json()
    |> Perspective.SaveLocalFile.save(path)
  end
end
