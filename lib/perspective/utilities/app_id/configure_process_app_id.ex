defmodule Perspective.ConfigureProcessAppId do
  import Perspective.NilPipe

  def configure(opts) do
    opts
    |> app_id_from_opts()
    |> nil_pipe(&app_id_from_ancestors/0)
    |> nil_pipe(&app_id_from_configuration/0)
    |> set()
  end

  defp app_id_from_opts(opts) do
    Perspective.AppIdFromOpts.find(opts)
  end

  defp app_id_from_ancestors do
    Perspective.AppIdFromAncestor.find(self())
  end

  defp app_id_from_configuration do
    Perspective.AppIdFromConfiguration.find()
  end

  defp set(nil) do
    raise Perspective.MissingAppIdConfiguration
  end

  defp set(app_id) when is_binary(app_id) do
    String.to_atom(app_id)
    |> set()
  end

  defp set(app_id) when is_atom(app_id) do
    Process.put(:app_id, app_id)
    app_id |> to_string()
  end
end
