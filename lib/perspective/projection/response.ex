defmodule Perspective.ProjectionResponse do
  import Perspective.StripElixir

  def channel_success(data, socket) do
    {:reply, {:ok, data}, socket}
  end

  def channel_error(error, socket) do
    {:reply, {:error, serialize_error(error)}, socket}
  end

  defp serialize_error(%type{} = error) do
    Map.from_struct(error)
    |> Map.put(:type, strip_elixir(type))
    |> Map.put(:message, type.message(error))
    |> Map.delete(:__exception__)
  end
end
