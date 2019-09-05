defmodule Perspective.BootAppPerTest do
  defmacro __using__(_) do
    quote do
      setup do
        app_id = "com.perspectivelib.test.#{UUID.uuid4()}"
        Perspective.Application.Supervisor.start_link(app_id: app_id)
        Process.put(:app_id, app_id)
        [app_id: app_id]
      end
    end
  end
end
