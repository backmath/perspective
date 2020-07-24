defmodule Perspective.ChildrenSpecs do
  def set_app_id({module}, app_id) do
    {module, app_id: app_id}
  end

  def set_app_id({module, options}, app_id) when is_list(options) do
    new_options = Keyword.put_new(options, :app_id, app_id)
    {module, new_options}
  end

  def set_app_id(module, app_id) when is_atom(module) do
    {module, app_id: app_id}
  end

  def set_app_id(list, app_id) when is_list(list) do
    Enum.map(list, &Perspective.ChildrenSpecs.set_app_id(&1, app_id))
  end

  def set_app_id(whatever, _app_id) do
    # IO.inspect(whatever, label: "unhandled ChildrenSpec.set_app_id handler")
    whatever
  end

  defp app_id do
    Perspective.ConfigureProcessAppId
  end
end
