defmodule Perspective.DomainEvent do
  defmacro transform_data(action_request, do: block) do
    quote do
      action_request_type = Module.get_attribute(unquote(__CALLER__.module), :action_request)

      def transform_data(%action_request_type{} = unquote(action_request)), do: unquote(block)

      defimpl Perspective.ActionRequest.RequestDataTransformer, for: action_request_type do
        def transform_data(%action_request_type{} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro transform_meta(action_request, do: block) do
    quote do
      action_request_type = Module.get_attribute(unquote(__CALLER__.module), :action_request)

      def transform_meta(%action_request_type{} = unquote(action_request)), do: unquote(block)

      defimpl Perspective.ActionRequest.MetadataTransformer, for: action_request_type do
        def transform_meta(%action_request_type{} = unquote(action_request)), do: unquote(block)
      end
    end
  end

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
