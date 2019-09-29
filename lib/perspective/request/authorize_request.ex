defmodule Perspective.AuthorizeRequest do
  defmacro __using__(_options) do
    quote do
      @before_compile Perspective.AuthorizeRequest
      import Perspective.AuthorizeRequest

      Module.register_attribute(__MODULE__, :stages, persist: true, accumulate: true)
    end
  end

  defmacro authorize(action_request, stage, block) when is_integer(stage) do
    definition = build_function(action_request, block)

    quote bind_quoted: [definition: definition, stage: stage] do
      Module.register_attribute(__MODULE__, :"stage_#{stage}", persist: true, accumulate: true)
      Module.put_attribute(__MODULE__, :"stage_#{stage}", definition)
      Module.put_attribute(__MODULE__, :stages, stage)
    end
  end

  defmacro authorize(action_request, block) do
    quote do
      authorize(unquote(action_request), 10, unquote(block))
    end
  end

  def build_function(action_request, block) do
    quote do
      def authorize(unquote(action_request)), unquote(block)
    end
    |> Macro.escape()
  end

  defmacro __before_compile__(_env) do
    calling_module = __CALLER__.module

    authorizing_functions = stages(calling_module)

    impl =
      if Enum.any?(authorizing_functions) do
        quote do
          defimpl Perspective.ActionRequest.RequestAuthorizer, for: __MODULE__ do
            unquote(authorizing_functions)
          end
        end
      end

    [
      authorizing_functions,
      impl
    ]
  end

  def stages(module) do
    Module.get_attribute(module, :stages)
    |> Enum.sort()
    |> Enum.uniq()
    |> Enum.flat_map(fn stage ->
      Module.get_attribute(module, :"stage_#{stage}")
      |> Enum.reverse()
    end)
  end
end
