defmodule Perspective.DomainEvent do
  @derive Jason.Encoder
  defstruct [:event_id, :event_date, :event_type, :request_date, :event]

  defmacro __using__(_options) do
    quote do
      import Kernel, except: [defstruct: 1]
      import Perspective.DomainEvent
      use Perspective.ModuleRegistry
      register_module(Perspective.DomainEvent)
    end
  end

  defmacro defstruct(args) do
    quote do
      Module.put_attribute(__MODULE__, :derive, Jason.Encoder)
      Kernel.defstruct(unquote(args))
    end
  end
end
