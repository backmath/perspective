defprotocol Perspective.Encode do
  @fallback_to_any true
  def encode(data)
end

defimpl Perspective.Encode, for: List do
  def encode(list) do
    Enum.map(list, &Perspective.Encode.encode/1)
  end
end

defimpl Perspective.Encode, for: DateTime do
  def encode(date) do
    DateTime.to_string(date)
  end
end

defimpl Perspective.Encode, for: Any do
  def encode(%struct_type{} = struct) do
    struct_name = String.replace("#{struct_type}", ~r/^Elixir./, "")

    Map.from_struct(struct)
    |> Map.put(:__perspective_struct__, struct_name)
    |> Enum.map(fn {k, v} ->
      {k, Perspective.Encode.encode(v)}
    end)
    |> Enum.into(%{})
  end

  def encode(data), do: data
end
