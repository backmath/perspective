defprotocol Perspective.Decode do
  @fallback_to_any true
  def decode(data)
end

defimpl Perspective.Decode, for: Any do
  def decode(%{"__perspective_struct__" => perspective_struct} = map) do
    map
    |> atomize_map()
    |> remove_key()
    |> build_struct(perspective_struct)
  end

  def decode(%{__perspective_struct__: perspective_struct} = map) do
    map
    |> remove_key()
    |> build_struct(perspective_struct)
  end

  defp atomize_map(map), do: Perspective.AtomizeKeys.atomize_keys(map)
  defp remove_key(map), do: Map.delete(map, :__perspective_struct__)

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

defimpl Perspective.Decode, for: [String, BitString, Binary] do
  def decode(binary), do: binary
end
