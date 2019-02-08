defmodule Perspective.EventChainStorage do
  use Perspective.Config

  def save(filepath \\ default_filepath()) do
    read_the_event_chain()
    |> serialize_the_chain()
    |> encode_to_json()
    |> write_to_file(filepath)
  end

  def read(filepath \\ default_filepath()) do
    load_file(filepath)
    |> decode_from_json
    |> map_to_event_structs
  end

  defp read_the_event_chain, do: Perspective.EventChain.list()
  defp encode_to_json(events), do: Jason.encode!(events)
  defp write_to_file(data, filepath), do: File.write!(filepath, data)
  defp load_file(filepath), do: File.read!(filepath)
  defp decode_from_json(data), do: Jason.decode!(data)

  defp serialize_the_chain(events) do
    Enum.map(events, fn %event_type{} = data ->
      Map.merge(data, %{event: event_type})
      |> Map.delete(:__struct__)
    end)
  end

  defp map_to_event_structs(events) do
    Enum.map(events, fn data ->
      event_type = data["event"] |> String.to_atom()
      struct(event_type, data)
    end)
  end

  defp default_filepath do
    "#{config(:path)}event-chain.json"
  end
end
