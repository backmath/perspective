defprotocol Perspective.Deserialize do
  @fallback_to_any true
  def deserialize(binary)
end

defimpl Perspective.Deserialize, for: Any do
  def deserialize(data) do
    data
    |> Jason.decode!()
    |> Perspective.Decode.decode()
  end
end
