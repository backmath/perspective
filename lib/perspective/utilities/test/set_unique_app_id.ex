defmodule Perspective.SetUniqueAppID do
  defmacro __using__(_) do
    quote do
      setup do
        app_id = "test-#{UUID.uuid4()}.perspectivelib.com"
        Process.put(:app_id, app_id)
        [app_id: app_id]
      end
    end
  end
end
