defmodule Perspective.EventChain.MoveEventsFromBufferToCurrentPage do
  def run do
    Perspective.EventChain.CurrentPage.event_count_remaining()
    |> Perspective.EventChain.PageBuffer.take_out()
    |> Perspective.EventChain.CurrentPage.add()
  end
end
