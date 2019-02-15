defmodule Perspective.DomainEvent do
  defmacro __using__(_options) do
    quote do
      import Perspective.DomainEvent
      use Perspective.ModuleRegistry
      register_module(Perspective.DomainEvent)
    end
  end
end
