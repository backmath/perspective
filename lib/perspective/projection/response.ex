defmodule Perspective.ProjectionResponse do
  def channel_success(data, socket) do
    {:reply, {:ok, data}, socket}
  end

  def channel_error(error, socket) do
    {:reply, {:error, serialize_error(error)}, socket}
  end

  defp serialize_error(%type{} = error) do
    %{
      type: String.replace("#{type}", ~r/^Elixir./, ""),
      message: type.message(error)
    }
  end
end
