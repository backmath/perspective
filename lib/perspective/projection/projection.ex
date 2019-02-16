defmodule Perspective.Projection do
  defmacro __using__(_) do
    quote do
      import Perspective.Projection
      @before_compile Perspective.Projection
      @updateable_events []

      def update(_event, _state) do
        raise "Update not specified"
      end

      def handle_info(data, state) do
        new_state = update(data, state)
        {:noreply, new_state}
      end

      def get do
        GenServer.call(__MODULE__, :state)
      end

      def handle_call(:state, _from, state) do
        {:reply, state, state}
      end

      defoverridable(update: 2)
    end
  end

  defmacro expose(path) do
    path
  end

  defmacro initial_state(do: block) do
    quote do
      def initial_state, do: unquote(block)
    end
  end

  defmacro update({_, _, [{_, _, [struct, _]}, _]} = event, state, do: block) do
    struct_name = Macro.expand_once(struct, __CALLER__)

    quote do
      @updateable_events [unquote(struct_name) | @updateable_events]
      def handle_info(unquote(event), _from, unquote(state)), do: unquote(block)
    end
  end

  defmacro __before_compile__(env) do
    updateable_events = Module.get_attribute(env.module, :updateable_events)
    calling_module = __CALLER__.module

    quote do
      use GenServer

      def init(_data) do
        unquote(updateable_events)
        |> Enum.each(fn event ->
          Perspective.Notifications.subscribe(struct(event, []))
        end)

        {:ok, initial_state()}
      end

      def start_link(data) do
        GenServer.start_link(unquote(calling_module), data, name: unquote(calling_module))
      end
    end
  end
end
