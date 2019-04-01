defmodule Perspective.EventChainStorage do
  use Perspective.Config

  def save(filepath \\ default_filepath()) do
    read_the_event_chain()
    |> convert_to_maps()
    |> encode_to_json()
    |> write_to_file(filepath)
  end

  def read(filepath \\ default_filepath()) do
    load_file(filepath)
    |> parse_file_load
    |> decode_from_json
    |> map_to_event_structs
  end

  defp read_the_event_chain, do: Perspective.EventChain.list()

  defp convert_to_maps(events) do
    Enum.map(events, fn event ->
      Perspective.DomainEventTransformers.to_map(event)
    end)
  end

  defp encode_to_json(events), do: Jason.encode!(events)
  defp write_to_file(data, filepath), do: File.write!(filepath, data)
  defp load_file(filepath), do: File.read(filepath)
  defp parse_file_load({:ok, file}), do: file
  defp parse_file_load({:error, _}), do: "[]"
  defp decode_from_json(data), do: Jason.decode!(data)

  defp map_to_event_structs(events) do
    Enum.map(events, fn data ->
      Perspective.DomainEventTransformers.from_map(atomize_keys(data))
    end)
  end

  defp atomize_keys(%{} = map) do
    for {k, v} <- map, into: %{} do
      case is_map(v) do
        true -> {String.to_atom(k), atomize_keys(v)}
        false -> {String.to_atom(k), v}
      end
    end
  end

  defp default_filepath do
    "#{config(:path)}event-chain.json"
  end
end
