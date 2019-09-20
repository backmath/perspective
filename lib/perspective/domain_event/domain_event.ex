defmodule Perspective.DomainEvent do
  defmacro __using__(_options) do
    quote do
      @before_compile Perspective.DomainEvent
      import Perspective.DomainEvent

      use Perspective.ModuleRegistry
      register_module(Perspective.DomainEvent)

      Module.register_attribute(__MODULE__, :action_request, persist: true)

      Module.put_attribute(__MODULE__, :derive, Jason.Encoder)
      Kernel.defstruct(id: "event:", actor_id: "_:", event_date: nil, data: %{}, meta: %{})
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def action_request, do: @action_request
    end
  end
end
