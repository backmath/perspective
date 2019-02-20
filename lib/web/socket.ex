defmodule Web.Socket do
  use Phoenix.Socket

  channel(Core.Projections.SystemTime.Channel.path(), Core.Projections.SystemTime.Channel)

  def connect(params, socket, connect_info) do
    IO.inspect(params)
    IO.inspect(connect_info)
    {:ok, socket}
  end

  def id(_socket), do: nil
end
