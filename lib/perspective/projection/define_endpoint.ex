defmodule Perspective.Projection.DefineEndpoint do
  def define(module, caller) do
    module_name = Perspective.ProjectionNames.endpoint(module)
    socket = Perspective.ProjectionNames.socket(module)
    router = Perspective.ProjectionNames.router(module)

    definition =
      quote bind_quoted: [socket: socket, router: router] do
        use Phoenix.Endpoint, otp_app: :perspective

        socket("/socket", socket, websocket: true, longpolling: false)

        plug(router)

        def init(:supervisor, config) do
          app_id = Perspective.AppID.fetch_and_set()

          Perspective.GenServer.References.store_process_references(__MODULE__, app_id: app_id)

          {:ok, config}
        end
      end

    Module.create(module_name, definition, Macro.Env.location(caller))

    module_name
  end
end
