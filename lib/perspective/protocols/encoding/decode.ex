defprotocol Perspective.Decode do
  @fallback_to_any true
  def decode(data)
end

defimpl Perspective.Decode, for: Map do
  def decode(%{"__perspective_struct__" => perspective_struct} = map) do
    map
    |> atomize_map()
    |> remove_key()
    |> decode_values()
    |> build_struct(perspective_struct)
  end

  def decode(%{__perspective_struct__: perspective_struct} = map) do
    map
    |> remove_key()
    |> decode_values()
    |> build_struct(perspective_struct)
  end

  def decode(map) do
    map
    |> decode_values()
  end

  defp atomize_map(map), do: Perspective.AtomizeKeys.atomize_keys(map)
  defp remove_key(map), do: Map.delete(map, :__perspective_struct__)

  defp decode_values(map) do
    map
    |> Enum.map(fn {k, v} ->
      {k, Perspective.Decode.decode(v)}
    end)
    |> Enum.into(%{})
  end

  defp build_struct(map, perspective_struct) do
    perspective_struct
    |> String.replace(~r/^/, "Elixir.")
    |> String.to_existing_atom()
    |> struct!(map)
  end
end

defimpl Perspective.Decode, for: List do
  def decode(list) do
    Enum.map(list, &Perspective.Decode.decode/1)
  end
end

defimpl Perspective.Decode, for: Any do
  def decode(data), do: data
end
