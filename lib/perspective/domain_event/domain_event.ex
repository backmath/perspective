defmodule Perspective.DomainEvent do
  defmacro __using__(_options) do
    quote do
      import Perspective.DomainEvent

      use Perspective.ModuleRegistry
      register_module(Perspective.DomainEvent)

      Module.register_attribute(__MODULE__, :action_request, persist: true)

      Module.put_attribute(__MODULE__, :derive, Jason.Encoder)
      Kernel.defstruct(id: "event:", actor_id: "_:", event_date: nil, data: %{}, meta: %{})
    end
  end
end
