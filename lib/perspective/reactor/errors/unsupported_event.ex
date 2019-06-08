defmodule Perspective.Reactor.UnsupportedEvent do
  defexception [:reactor, :event]

  def exception(reactor: reactor, event: event) do
    %__MODULE__{
      reactor: reactor,
      event: event
    }
  end

  def message(%__MODULE__{reactor: reactor, event: event}) do
    "The following event was provided to #{reactor}, but is not supported:\n#{event}"
  end
end
