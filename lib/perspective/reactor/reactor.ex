defmodule Perspective.Reactor do
  defmacro __using__(_) do
    quote do
      import Perspective.Reactor
      use Perspective.ModuleRegistry
      register_module(Perspective.Reactor)

      @before_compile Perspective.Reactor
      @updateable_events []

      def initial_state, do: nil

      def preprocess_data(_event, original_data), do: original_data
      def postprocess_data(_event, updated_data, original_data), do: updated_data

      defoverridable(initial_state: 0, preprocess_data: 2, postprocess_data: 3)

      defmodule Updated do
        defstruct [:data]
      end

      def broadcast(_event, new_state, _old_state) do
        Perspective.Notifications.emit(%Updated{data: new_state})
      end

      defoverridable(broadcast: 3)
    end
  end

  defmacro initial_state(do: block) do
    quote do
      def initial_state, do: unquote(block)
    end
  end

  defmacro broadcast(event, new_state, old_state, do: block) do
    quote do
      def broadcast(unquote(event), unquote(new_state), unquote(old_state)), do: unquote(block)
    end
  end

  defmacro update(event, state, do: block) do
    struct_type =
      Perspective.Reactor.MacroParser.capture_event_name(event)
      |> Macro.expand(__CALLER__)

    quote do
      @updateable_events [unquote(struct_type) | @updateable_events]
      def update(unquote(event), unquote(state)), do: unquote(block)
    end
  end

  defmacro __before_compile__(env) do
    updateable_events = Module.get_attribute(env.module, :updateable_events)
    calling_module = __CALLER__.module

    Perspective.Reactor.DefineGenServer.define(calling_module, updateable_events, __CALLER__)
    Perspective.Reactor.DefineSupervisor.define(calling_module, __CALLER__)

    supervisor_name = Perspective.Reactor.Names.server(calling_module)
    genserver_name = Perspective.Reactor.Names.server(calling_module)

    quote do
      defdelegate state, to: unquote(genserver_name)
      defdelegate data, to: unquote(genserver_name)
      defdelegate get, to: unquote(genserver_name), as: :state
      defdelegate send(event), to: unquote(genserver_name)
      defdelegate start_link, to: unquote(supervisor_name)
      defdelegate start_link(opts), to: unquote(supervisor_name)

      def updateable_events do
        unquote(updateable_events)
      end

      def update(event, _state) do
        raise Perspective.Reactor.UnsupportedEvent, reactor: unquote(calling_module), event: event
      end

      def child_spec(opts) do
        %{
          id: unquote(calling_module),
          start: {unquote(supervisor_name), :start_link, [opts]},
          type: :worker
        }
      end
    end
  end
end
