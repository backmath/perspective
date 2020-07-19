defmodule Perspective.AppIdFromOpts do
  def find(opts) when is_list(opts) do
    Keyword.get(opts, :app_id)
  end

  def find(%{app_id: app_id}) do
    app_id
  end

  def find(_) do
    nil
  end
end
