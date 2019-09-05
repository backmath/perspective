defmodule Perspective.EventChain.PageManifest.State.Test do
  use ExUnit.Case, async: true
  alias Perspective.EventChain.PageManifest.State

  test "new" do
    result = State.new()

    expected = %State{
      pages: ["event-chain.0000000.json"]
    }

    assert expected == result
  end

  test "add_page" do
    result =
      State.new()
      |> State.add_page()

    expected = %State{
      pages: [
        "event-chain.0000000.json",
        "event-chain.0000001.json"
      ]
    }

    assert expected == result
  end

  test "current_page" do
    result =
      State.new()
      |> State.add_page()
      |> State.add_page()
      |> State.current_page()

    expected = "event-chain.0000002.json"

    assert expected == result
  end
end
