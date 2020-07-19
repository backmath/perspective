defmodule Perspective.AppIDFromProcess.Test do
  use ExUnit.Case

  test "a process' default app_id is nil" do
    app_id = Perspective.AppIdFromProcess.find()

    assert nil === app_id
  end

  test "a process' set app_id may be retrieved" do
    Process.put(:app_id, "some-app-id")

    app_id = Perspective.AppIdFromProcess.find()

    assert "some-app-id" == app_id
  end
end
