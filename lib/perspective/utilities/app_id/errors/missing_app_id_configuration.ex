defmodule Perspective.MissingAppIdConfiguration do
  defexception [:module, :key]

  def exception do
    %__MODULE__{}
  end

  def message(_) do
    """
    :app_id configuration failed

    Calling Perspective.ConfigureProcessAppId.config/1 requires one of the following:

    - a valid opts argument with the desired app_id,
    - a supervising ancestor with their app_id configured, or
    - a valid Elixir configuration (i.e., config Perspecitve.Appliction, :app_id, "your-app-id")
    """
  end
end
