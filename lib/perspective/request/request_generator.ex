defmodule Perspective.RequestGenerator do
  def from(%{data: data} = map) do
    try do
      map
      # |> map_to_action_request()
      # |> set_action_from_data(data)
      # |> Map.put(:request_id, "request:" <> UUID.uuid4())
      # |> Map.put(:request_date, DateTime.utc_now() |> DateTime.to_iso8601())
    rescue
      error in Perspective.Request.MissingAction -> {:error, error}
    end
  end

  defp map_to_action_request(%{} = map) do
    struct(Perspective.ActionRequest, map)
  end

  defp create_action(action_name, data) do
    try do
      struct_name = String.to_existing_atom("Elixir.#{action_name}")
      struct(struct_name, data)
    rescue
      _error in ArgumentError -> raise Perspective.Request.MissingAction, action_name
    end
  end
end
