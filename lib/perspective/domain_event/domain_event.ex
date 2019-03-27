defmodule Perspective.DomainEvent do
  defmacro __using__(_options) do
    quote do
      import Perspective.DomainEvent
      use Perspective.ModuleRegistry
      register_module(Perspective.DomainEvent)

      Kernel.defstruct([:id, :actor_id, :data, :meta, :event_date])
    end
  end
end
