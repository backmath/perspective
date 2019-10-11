defmodule Perspective.Processor.RequestGenerator do
  import Perspective.StripElixir

  def generate(%action{data: data}) do
    create_action(action, data)
  end

  def generate(%{data: data, action: action}) do
    create_action(action, data)
  end

  def generate(%{"data" => data, "action" => action}) do
    generate(%{data: data, action: action})
  end

  def generate(abc) do
    raise "The provided request had no matcher: #{abc}"
  end

  defp create_action(action_name, data) do
    try do
      struct_name = String.to_existing_atom("Elixir.#{strip_elixir(action_name)}")
      struct_name.new(nil, Perspective.AtomizeKeys.atomize_keys(data))
    rescue
      _error in ArgumentError -> raise Perspective.Request.MissingAction, action_name
    end
  end
end
