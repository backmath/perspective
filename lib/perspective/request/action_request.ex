defmodule Perspective.ActionRequest do
  defmacro validate_syntax(action_request, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def validate_syntax(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)

      defimpl Perspective.ActionRequest.SyntaxValidator, for: unquote(calling_module) do
        def validate_syntax(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro validate_semantics(action_request, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def validate_semantics(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)

      defimpl Perspective.ActionRequest.SemanticValidator, for: unquote(calling_module) do
        def validate_semantics(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro transform_data(action_request, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def transform_data(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)

      defimpl Perspective.ActionRequest.RequestDataTransformer, for: unquote(calling_module) do
        def transform_data(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro transform_meta(action_request, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def transform_meta(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)

      defimpl Perspective.ActionRequest.MetadataTransformer, for: unquote(calling_module) do
        def transform_meta(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro domain_event(domain_event_name, domain_event_version) do
    quote do
      @domain_event_name unquote(domain_event_name)
      @domain_event_version unquote(domain_event_version)
    end
  end

  defmacro __using__(_options) do
    quote do
      @before_compile Perspective.ActionRequest
      import Perspective.ActionRequest
      use Perspective.AuthorizeRequest
      use Perspective.ModuleRegistry
      register_module(Perspective.ActionRequest)
      Module.register_attribute(__MODULE__, :domain_event_name, persist: true)
      Module.register_attribute(__MODULE__, :domain_event_version, persist: true)

      Module.put_attribute(__MODULE__, :derive, Jason.Encoder)
      Kernel.defstruct(id: "request/undefined", actor_id: nil, data: %{}, meta: %{})

      def new(actor_id \\ nil, data \\ %{}, meta \\ default_meta()) do
        %__MODULE__{
          id: "request/" <> UUID.uuid4(),
          actor_id: actor_id,
          data: data,
          meta: meta
        }
      end

      defp default_meta do
        %{
          request_date: DateTime.utc_now()
        }
      end
    end
  end

  defmacro __before_compile__(_) do
    domain_event_name = Module.get_attribute(__CALLER__.module, :domain_event_name)
    domain_event_version = Module.get_attribute(__CALLER__.module, :domain_event_version)

    unless domain_event_name || domain_event_version do
      raise Perspective.ActionRequest.MissingOrInvalidDomainEvent, module: __CALLER__.module
    end

    Perspective.ActionRequest.DefineEvent.define(domain_event_name, __CALLER__)

    quote do
      def domain_event_name, do: unquote(domain_event_name)
      def domain_event_version, do: unquote(domain_event_version)
    end
  end
end
