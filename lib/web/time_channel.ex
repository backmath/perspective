defmodule Web.TimeChannel do
  use Phoenix.Channel

  def join("home://time", _message, socket) do
    IO.inspect(socket)

    Process.send_after(self(), :ack, 5000)

    {:ok, socket}
  end

  def handle_in("get", _message, socket) do
    data = %{time: DateTime.utc_now()}

    push(socket, "get", data)

    {:reply, {:ok, data}, socket}
  end

  def handle_in(event, _message, socket) do
    raise "Unhandled event #{event} for topic home://important_things"

    {:noreply, socket}
  end

  def handle_info(:ack, socket) do
    Web.Endpoint.broadcast!("home://time", "update", %{time: DateTime.utc_now()})
    Process.send_after(self(), :ack, 5000)
    {:noreply, socket}
  end
end
