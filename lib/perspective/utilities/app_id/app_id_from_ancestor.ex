defmodule Perspective.AppIdFromAncestor do
  def find(pid) do
    ancestors(pid)
    |> Enum.reduce_while(nil, fn ancestor, _acc ->
      case app_id(ancestor) do
        nil -> {:cont, nil}
        value -> {:halt, value}
      end
    end)
  end

  defp ancestors(pid) when is_pid(pid) do
    Process.info(pid)
    |> Keyword.get(:dictionary, [])
    |> Keyword.get(:"$ancestors", [])
  end

  defp app_id(pid) when is_pid(pid) do
    Process.info(pid)
    |> Keyword.get(:dictionary, [])
    |> Keyword.get(:app_id, nil)
  end

  defp app_id(_pid), do: nil
end
