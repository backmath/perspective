defmodule Web.Socket do
  use Perspective.Socket

  projection(Core.Projections.SystemTime)

  def connect(params, socket, connect_info) do
    IO.inspect(params)
    IO.inspect(connect_info)
    {:ok, socket}
  end

  def id(_socket), do: nil
end
