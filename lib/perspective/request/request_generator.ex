defmodule Perspective.RequestGenerator do
  def from!(%{data: data, action: action}) do
    create_action(action, data)
  end

  def from!(%{"data" => data, "action" => action}) do
    from!(%{data: data, action: action})
  end

  def from!(abc) do
    raise "The provided request had no matcher: #{abc}"
  end

  defp create_action(action_name, data) do
    try do
      struct_name = String.to_existing_atom("Elixir.#{action_name}")
      struct_name.new(nil, data)
    rescue
      _error in ArgumentError -> raise Perspective.Request.MissingAction, action_name
    end
  end
end
