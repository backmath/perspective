defmodule Perspective.AppIdFromOpts.Test do
  use ExUnit.Case, async: true

  test "Perspective.AppIdFromOpts.find requires a map or list" do
    app_id = Perspective.AppIdFromOpts.find("some-non-list-or-map")

    assert nil == app_id
  end

  test "AppIdFromOpts accepts maps" do
    app_id = Perspective.AppIdFromOpts.find(%{app_id: "some-app-id"})

    assert "some-app-id" == app_id
  end

  test "a process with an ancestor having :app_id returns that id" do
    app_id = Perspective.AppIdFromOpts.find(app_id: "some-app-id")

    assert "some-app-id" == app_id
  end
end
