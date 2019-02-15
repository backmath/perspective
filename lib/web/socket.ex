defmodule Web.Socket do
  use Phoenix.Socket

  channel("home://important_things", Web.Channel)
  channel("home://time", Web.TimeChannel)
  channel("perspective://requests", Web.RequestsChannel)

  def connect(params, socket, connect_info) do
    IO.inspect(params)
    IO.inspect(connect_info)
    {:ok, socket}
  end

  def id(_socket), do: nil
end
