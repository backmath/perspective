defmodule Perspective.BootAppPerTest do
  defmacro __using__(_) do
    quote do
      use Perspective.SetUniqueAppID

      setup %{app_id: app_id} do
        Perspective.Application.Supervisor.start_link(app_id: app_id)
        :ok
      end
    end
  end
end

defmodule Perspective.SetUniqueAppID do
  defmacro __using__(_) do
    quote do
      setup do
        app_id = "com.perspectivelib.test.#{UUID.uuid4()}"
        Process.put(:app_id, app_id)
        [app_id: app_id]
      end
    end
  end
end
