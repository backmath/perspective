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
    arguments = [:event_id | [:date | args]]

    quote do
      Kernel.defstruct(unquote(arguments))
    end
  end
end
