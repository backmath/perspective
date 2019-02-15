defmodule Web.RequestChannel do
  use Phoenix.Channel

  def join("perspective://requests", _message, socket) do
    IO.inspect(socket)

    # Create socket ref, register

    {:ok, socket}
  end

  # def handle_in("submit")

  def handle_in("get", %{request_id: request_id}, socket) do
    push(socket, "get", request_id)

    {:reply, {:ok, request_id}, socket}
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

applications = :application.loaded_applications()

Enum.reduce(applications, [], fn {app, _desc, _version}, acc ->
  {:ok, modules} = :application.get_key(app, :modules)

  new_modules =
    Enum.filter(modules, fn m ->
      String.starts_with?(to_string(m), "Elixir.Special.Registry.Auto.")
    end)

  new_modules ++ acc
end)
