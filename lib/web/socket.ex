defmodule Web.Socket do
  use Phoenix.Socket

  # channel("home://important_things", Web.Channel)
  channel(Core.System.SystemTime.Channel.path(), Core.System.SystemTime.Channel)

  def connect(params, socket, connect_info) do
    IO.inspect(params)
    IO.inspect(connect_info)
    {:ok, socket}
  end

  def id(_socket), do: nil
end
