defmodule Perspective.EventChainStorage do
  use Perspective.Config

  def save(filepath \\ default_filepath()) do
    read_the_event_chain()
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

  defp map_to_event_structs(events) do
    # @todo Create a Perspective.DomainEvent.from
    Enum.map(events, fn data ->
      struct(Perspective.DomainEvent, atomize_keys(data))
      |> map_domain_event()
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

  def map_domain_event(%{event_type: event_type, event: event} = domain_event) do
    event_type = event_type |> String.replace(~r/^/, "Elixir.") |> String.to_existing_atom()

    domain_event
    |> Map.put(:event, struct(event_type, event))
    |> Map.put(:event_type, event_type)
  end

  defp default_filepath do
    "#{config(:path)}event-chain.json"
  end
end
