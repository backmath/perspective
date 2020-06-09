defmodule Perspective.AppIDLookup do
  def fetch_and_set do
    case fetch_from_process_dictionary() do
      nil -> lookup_from_ancestors_and_set()
      app_id -> app_id
    end
  end

  defp fetch_from_process_dictionary do
    Process.get(:app_id)
  end

  defp lookup_from_ancestors_and_set do
    app_id = Perspective.AncestralAppID.find(self())

    Process.put(:app_id, app_id)

    app_id
  end
end
