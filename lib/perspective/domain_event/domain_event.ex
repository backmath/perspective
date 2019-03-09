defmodule Perspective.DomainEvent do
  defmacro __using__(_options) do
    quote do
      import Kernel, except: [defstruct: 1]
      import Perspective.DomainEvent
      use Perspective.ModuleRegistry
      register_module(Perspective.DomainEvent)
    end
  end

  defmacro defstruct(args) do
    # todo: throw an error if args contians an event, date key
    arguments = [:domain_event_id | [:domain_event_date | args]]

    quote do
      Kernel.defstruct(unquote(arguments))
    end
  end
end
