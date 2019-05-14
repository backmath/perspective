defprotocol Perspective.AtomizeKeys do
  def atomize_keys(action)
end

defimpl Perspective.AtomizeKeys, for: Map do
  def atomize_keys(%{} = map) do
    for {k, v} <- map, into: %{} do
      case is_map(v) do
        true -> {atomize(k), atomize_keys(v)}
        false -> {atomize(k), v}
      end
    end
  end

  defp atomize(value) when is_binary(value), do: String.to_atom(value)
  defp atomize(value), do: value
end
