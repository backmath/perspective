defmodule Perspective.Projection do
  defmacro __using__(_) do
    quote do
      import Perspective.Projection
      use Perspective.ProjectionRegistry

      Module.register_attribute(__MODULE__, :channel_exposures, persist: true, accumulate: true)
      Module.register_attribute(__MODULE__, :controller_exposures, persist: true, accumulate: true)
      Module.register_attribute(__MODULE__, :broadcaster_exposures, persist: true, accumulate: true)

      @before_compile Perspective.Projection
    end
  end

  defmacro expose(path, reactor) do
    reactor_name = Macro.expand(reactor, __CALLER__)

    channel_name = Perspective.Projection.DefineChannel.define(path, reactor_name, __CALLER__)
    controller_name = Perspective.Projection.DefineController.define(path, reactor_name, __CALLER__)
    broadcaster_name = Perspective.Projection.DefineBroadcaster.define(path, reactor_name, __CALLER__)

    quote bind_quoted: [
            path: path,
            channel_name: channel_name,
            controller_name: controller_name,
            broadcaster_name: broadcaster_name
          ] do
      Module.put_attribute(__MODULE__, :channel_exposures, {path, channel_name})
      Module.put_attribute(__MODULE__, :controller_exposures, {path, controller_name})
      Module.put_attribute(__MODULE__, :broadcaster_exposures, {path, broadcaster_name})
    end
  end

  defmacro __before_compile__(_) do
    channel_exposures = Module.get_attribute(__CALLER__.module, :channel_exposures)
    controller_exposures = Module.get_attribute(__CALLER__.module, :controller_exposures)
    broadcaster_exposures = Module.get_attribute(__CALLER__.module, :broadcaster_exposures)

    Perspective.Projection.DefineRouter.define(controller_exposures, __CALLER__.module, __CALLER__)
    Perspective.Projection.DefineSocket.define(channel_exposures, __CALLER__.module, __CALLER__)
    Perspective.Projection.DefineEndpoint.define(__CALLER__.module, __CALLER__)
    Perspective.Projection.DefineSupervisor.define(broadcaster_exposures, __CALLER__.module, __CALLER__)

    quote do
    end
  end
end
