defmodule Perspective.AppIdFromProcess do
  def find do
    Process.get(:app_id)
  end
end
