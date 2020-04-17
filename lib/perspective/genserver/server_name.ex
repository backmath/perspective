defmodule Perspective.ServerName do
  def name(module) do
    app_id = Process.get(:app_id)

    name(module, app_id)
  end

  def name(module, opts) when is_list(opts) do
    app_id = Keyword.get(opts, :app_id)

    case Keyword.get(opts, :name) do
      nil -> module
      value -> value
    end
    |> name(app_id)
  end

  def name(module, opts) when is_map(opts) do
    name(module, Map.to_list(opts))
  end

  def name(module, nil) do
    {:global, "#{strip_elixir(module)}"}
  end

  def name(module, "") do
    {:global, "#{strip_elixir(module)}"}
  end

  def name(module, app_id) when is_binary(app_id) do
    {:global, "#{app_id}.#{strip_elixir(module)}"}
  end

  def name(module, _) do
    {:global, "#{strip_elixir(module)}"}
  end

  defp strip_elixir(module) do
    String.replace("#{module}", ~r/^Elixir./, "")
  end
end
