defmodule Perspective.Projection do
  defmacro __using__(_) do
    quote do
      import Perspective.Projection
      use Perspective.ProjectionRegistry

      Module.register_attribute(__MODULE__, :exposures, persist: true, accumulate: true)

      @before_compile Perspective.Projection
    end
  end

  defmacro expose(path, reactor) do
    reactor_name = Macro.expand(reactor, __CALLER__)

    Perspective.Projection.DefineChannel.define(path, reactor_name, __CALLER__)
    Perspective.Projection.DefineController.define(path, reactor_name, __CALLER__)
    Perspective.Projection.DefineBroadcaster.define(path, reactor_name, __CALLER__)

    quote bind_quoted: [path: path, reactor_name: reactor_name] do
      Module.put_attribute(__MODULE__, :exposures, {path, reactor_name})
    end
  end

  defmacro __before_compile__(_) do
    exposures = Module.get_attribute(__CALLER__.module, :exposures)

    Perspective.Projection.DefineRouter.define(exposures, __CALLER__.module, __CALLER__)
    Perspective.Projection.DefineSocket.define(exposures, __CALLER__.module, __CALLER__)
    Perspective.Projection.DefineEndpoint.define(__CALLER__.module, __CALLER__)
    Perspective.Projection.DefineSupervisor.define(exposures, __CALLER__.module, __CALLER__)

    quote do
    end
  end
end
