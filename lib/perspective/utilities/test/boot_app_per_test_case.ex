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

defmodule Perspective.LaunchANewInstancePerTest do
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
