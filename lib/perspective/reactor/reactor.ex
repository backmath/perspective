defmodule Perspective.Reactor do
  defmacro __using__(_) do
    calling_module = __CALLER__.module

    quote do
      import Perspective.Reactor
      @before_compile Perspective.Reactor
      @updateable_events []

      def update(event, _state) do
        raise "Update (#{event.__struct__}) has no matching function"
      end

      def backup(_event, _state), do: nil

      def handle_info(event, state) do
        new_state = update(event, state)

        emit_reactor_update()

        generate_backup(event, state)

        {:noreply, new_state}
      end

      def get do
        GenServer.call(__MODULE__, :state)
      end

      def handle_call(:state, _from, state) do
        {:reply, state, state}
      end

      def handle_call(:reset, _from, state) do
        state = run_initial_state(load_backup())
        {:reply, state, state}
      end

      def send(event) do
        Kernel.send(unquote(calling_module), event)
      end

      def reset() do
        File.rm("./storage/test/#{unquote(calling_module)}.backup.json")

        GenServer.call(unquote(calling_module), :reset)
      end

      def emit_reactor_update do
        %Perspective.Reactor.ReactorUpdated{
          module: unquote(calling_module),
          pid: self()
        }
        |> Perspective.Notifications.emit()
      end

      def load_backup() do
        case File.read("./storage/test/#{unquote(calling_module)}.backup.json") do
          {:ok, data} -> Jason.decode!(data)
          {:error, _} -> nil
        end
      end

      def generate_backup(event, state) do
        backup =
          backup(event, state)
          |> Jason.encode!()

        File.write!("./storage/test/#{unquote(calling_module)}.backup.json", backup)
      end

      def initial_state(_) do
        nil
      end

      defoverridable(update: 2, backup: 2, initial_state: 1)
    end
  end

  defmacro initial_state(backup_state, do: block) do
    quote do
      def run_initial_state(unquote(backup_state)), do: unquote(block)
    end
  end

  defmacro initial_state(do: block) do
    quote do
      def run_initial_state(_), do: unquote(block)
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

  defmacro backup(event, state, do: block) do
    quote do
      def backup(unquote(event), unquote(state)), do: unquote(block)
    end
  end

  defmacro __before_compile__(env) do
    updateable_events = Module.get_attribute(env.module, :updateable_events)
    calling_module = __CALLER__.module

    quote do
      use GenServer

      def init(_data) do
        subscribe_to(unquote(updateable_events))

        {:ok, run_initial_state(load_backup())}
      end

      def start_link(_data) do
        GenServer.start_link(unquote(calling_module), nil, name: unquote(calling_module))
      end

      def start do
        start_link(nil)
      end

      defp subscribe_to(updateable_events) do
        Enum.each(updateable_events, fn event ->
          Perspective.Notifications.subscribe(struct(event, []))
        end)
      end
    end
  end
end
