defprotocol Perspective.Serialize do
  @fallback_to_any true
  def to_json(struct)
end

defimpl Perspective.Serialize, for: Any do
  def to_json(data) do
    data
    |> Perspective.Encode.encode()
    |> Jason.encode!(pretty: true)
  end
end
