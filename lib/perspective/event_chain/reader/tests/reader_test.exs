defmodule Perspective.EventChain.Reader.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  defmodule Example do
    defstruct [:id]
  end

  test "all" do
    Perspective.EventChain.apply_event(%Example{id: "a"})
    Perspective.EventChain.apply_event(%Example{id: "b"})
    Perspective.EventChain.apply_event(%Example{id: "c"})
    Perspective.EventChain.apply_event(%Example{id: "d"})

    result =
      Perspective.TestSupport.call_repeatedly(fn ->
        Perspective.EventChain.Reader.all()
        |> Enum.to_list()
        |> case do
          [] -> raise "retry"
          result -> result
        end
      end)

    expected = [
      %Example{id: "a"},
      %Example{id: "b"},
      %Example{id: "c"},
      %Example{id: "d"}
    ]

    assert expected == result
  end

  test "since(nil) behaves just like all()" do
    Perspective.EventChain.apply_event(%Example{id: "a"})
    Perspective.EventChain.apply_event(%Example{id: "b"})
    Perspective.EventChain.apply_event(%Example{id: "c"})
    Perspective.EventChain.apply_event(%Example{id: "d"})

    result =
      Perspective.TestSupport.call_repeatedly(fn ->
        Perspective.EventChain.Reader.since(nil)
        |> Enum.to_list()
        |> case do
          [] -> raise "retry"
          result -> result
        end
      end)

    expected = [
      %Example{id: "a"},
      %Example{id: "b"},
      %Example{id: "c"},
      %Example{id: "d"}
    ]

    assert expected == result
  end

  test "since(event_id) streams all events after that id" do
    Perspective.EventChain.apply_event(%Example{id: "a"})
    Perspective.EventChain.apply_event(%Example{id: "b"})
    Perspective.EventChain.apply_event(%Example{id: "c"})
    Perspective.EventChain.apply_event(%Example{id: "d"})

    result =
      Perspective.TestSupport.call_repeatedly(fn ->
        Perspective.EventChain.Reader.since("b")
        |> Enum.to_list()
        |> case do
          [] -> raise "retry"
          result -> result
        end
      end)

    assert [%Example{id: "c"}, %Example{id: "d"}] == result
  end
end
