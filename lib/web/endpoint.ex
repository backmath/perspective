defmodule Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :perspective

  socket("/socket", Web.Socket, websocket: true, longpolling: false)

  # if code_reloading? do
  #   socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
  #   plug Phoenix.CodeReloader
  #   plug Phoenix.LiveReloader
  # end

  plug(Web.Router)
end
