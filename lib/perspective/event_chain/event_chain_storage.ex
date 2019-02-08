# rename to storage
defmodule Perspective.EventChainBackup do
  use Perspective.Config

  # rename to save
  def save(filepath \\ default_filepath()) do
    json =
      Perspective.EventChain.list()
      |> Enum.map(fn %event_type{} = data ->
        Map.merge(data, %{event: event_type})
        |> Map.delete(:__struct__)
      end)
      |> Jason.encode!()

    File.write!(filepath, json)
  end

  def read(filepath \\ default_filepath()) do
    load_file(filepath)
    |> decode_from_json
    |> map_to_event_structs
  end

  defp load_file(filepath), do: File.read!(filepath)
  defp decode_from_json(data), do: Jason.decode!(data)
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
