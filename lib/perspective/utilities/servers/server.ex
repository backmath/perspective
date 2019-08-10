defmodule Perspective.Server do
  def name(module, nil), do: name(module)

  def name(module, ""), do: name(module)

  def name(module, app_id: app_id) do
    {:global, "#{app_id}.#{strip_elixir(module)}"}
  end

  def name(module, app_id) when is_binary(app_id) do
    {:global, "#{app_id}.#{strip_elixir(module)}"}
  end

  def name(module, _), do: name(module)

  def name(module) do
    {:global, "#{strip_elixir(module)}"}
  end

  defp strip_elixir(module) do
    String.replace("#{module}", ~r/^Elixir./, "")
  end
end
