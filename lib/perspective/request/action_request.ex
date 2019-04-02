defmodule Perspective.ActionRequest do
  defmacro validate_syntax(action_request, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def validate_syntax(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)

      def validate_syntax(%wrong_type{} = action) do
        raise(Perspective.Action.WrongActionType, {action, unquote(calling_module)})
      end

      defimpl Perspective.ActionRequest.SyntaxValidator, for: unquote(calling_module) do
        def validate_syntax(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro validate_semantics(action_request, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def validate_semantics(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)

      def validate_semantics(%wrong_type{} = action) do
        raise(Perspective.Action.WrongActionType, {action, unquote(calling_module)})
      end

      defimpl Perspective.ActionRequest.SemanticValidator, for: unquote(calling_module) do
        def validate_semantics(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro authorize_request(action_request, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def authorize_request(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)

      def authorize_request(%wrong_type{} = action) do
        raise(Perspective.Action.WrongActionType, {action, unquote(calling_module)})
      end

      defimpl Perspective.ActionRequest.RequestAuthorizer, for: unquote(calling_module) do
        def authorize_request(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro event_data(action_request, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def event_data(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)

      def event_data(%wrong_type{} = action) do
        raise(Perspective.Action.WrongActionType, {action, unquote(calling_module)})
      end

      defimpl Perspective.ActionRequest.RequestDataTransformer, for: unquote(calling_module) do
        def event_data(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro event_meta(action_request, do: block) do
    calling_module = __CALLER__.module()

    quote do
      def event_meta(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)

      def event_meta(%wrong_type{} = action) do
        raise(Perspective.Action.WrongActionType, {action, unquote(calling_module)})
      end

      defimpl Perspective.ActionRequest.MetadataTransformer, for: unquote(calling_module) do
        def event_meta(%unquote(calling_module){} = unquote(action_request)), do: unquote(block)
      end
    end
  end

  defmacro event_name(name) do
    # test if struct exists someday
    quote do
      def event_name(), do: unquote(name)
    end
  end

  defmacro __using__(_options) do
    quote do
      import Perspective.ActionRequest
      use Perspective.ModuleRegistry
      register_module(Perspective.ActionRequest)

      Module.put_attribute(__MODULE__, :derive, Jason.Encoder)
      Kernel.defstruct(id: "request/", actor_id: "_:", data: %{}, meta: %{}, errors: [])

      def new(data \\ %{}, actor_id \\ default_actor_id(), meta \\ default_meta()) do
        %__MODULE__{
          id: "request/" <> UUID.uuid4(),
          actor_id: actor_id,
          data: data,
          meta: meta
        }
      end

      defp default_actor_id do
        "#{Mix.env()}:anonymous"
      end

      defp default_meta do
        %{
          request_date: DateTime.utc_now()
        }
      end
    end
  end
end
