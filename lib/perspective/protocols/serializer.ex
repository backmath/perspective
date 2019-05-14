defprotocol Perspective.Serializer do
  @fallback_to_any true
  def to_json(struct)
  def from_json(binary)
end

defimpl Perspective.Serializer, for: Any do
  def to_json(%struct_type{} = struct) when is_map(struct) do
    Map.from_struct(struct)
    |> Map.put(:__perspective__struct__, struct_type)
    |> Jason.encode!()
  end

  def from_json(binary) when is_binary(binary) do
    map =
      Jason.decode!(binary)
      |> Perspective.AtomizeKeys.atomize_keys()

    case perspective_struct_atom(map) do
      nil -> map
      perspective_struct_name -> struct(perspective_struct_name, map)
    end
  end

  defp perspective_struct_atom(map) do
    try do
      String.to_existing_atom(map.__perspective__struct__)
    rescue
      ArgumentError -> nil
    end
  end
end
