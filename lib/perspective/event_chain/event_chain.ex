defmodule Perspective.EventChain do
  def apply_event(event) do
    Perspective.EventChain.PageBuffer.add(event)
    # Perspective.Notifications.emit(event)
  end

  def all() do
    Perspective.EventChain.Reader.all()
  end

  def since(id) do
    Perspective.EventChain.Reader.since(id)
  end
end
