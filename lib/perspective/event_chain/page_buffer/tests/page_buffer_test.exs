defmodule Perspective.EventChain.PageBuffer.Test do
  use Perspective.TestCase

  setup do
    Perspective.EventChain.PageBuffer.clear()
  end

  test "take_out when empty" do
    assert [] == Perspective.EventChain.PageBuffer.take_out(0)
  end

  test "add_event" do
    Perspective.EventChain.PageBuffer.add(%{id: "abc"})
    assert [%{id: "abc"}] == Perspective.EventChain.PageBuffer.take_out(1)
  end

  test "take_out some" do
    Perspective.EventChain.PageBuffer.add(%{id: "abc"})
    Perspective.EventChain.PageBuffer.add(%{id: "hij"})
    Perspective.EventChain.PageBuffer.add(%{id: "xyz"})

    assert [%{id: "abc"}, %{id: "hij"}] == Perspective.EventChain.PageBuffer.take_out(2)
    assert [%{id: "xyz"}] == Perspective.EventChain.PageBuffer.take_out(2)
  end
end
