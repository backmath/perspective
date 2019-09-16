defmodule Perspective.Projection.DefineEndpoint do
  def define(module, caller) do
    name = Module.concat(module, PhoenixEndpoint)
    socket = Module.concat(module, ProjectionSocket)
    router = Module.concat(module, ProjectionRouter)

    definition =
      quote bind_quoted: [socket: socket, router: router] do
        use Phoenix.Endpoint, otp_app: :perspective

        socket("/socket", socket, websocket: true, longpolling: false)

        plug(router)

        def init(:supervisor, config) do
          app_id = Perspective.AppID.fetch_and_set()

          Perspective.ServerReferences.store_process_references(__MODULE__, app_id: app_id)

          {:ok, config}
        end
      end

    Module.create(name, definition, Macro.Env.location(caller))
  end
end
