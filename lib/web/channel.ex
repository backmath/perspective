defmodule Web.Channel do
  use Phoenix.Channel

  def join("home://important_things", _message, socket) do
    IO.inspect(socket)

    {:ok, socket}
  end

  def handle_in("get", _message, socket) do
    data = %{important_things_completed: 0}

    push(socket, "get", data)

    {:reply, {:ok, data}, socket}
  end

  def handle_in("update", _message, socket) do
    data = %{important_things_completed: 10}

    broadcast!(socket, "update", data)

    {:reply, {:ok, data}, socket}
  end

  def handle_in(event, _message, socket) do
    raise "Unhandled event #{event} for topic home://important_things"

    {:noreply, socket}
  end
end
