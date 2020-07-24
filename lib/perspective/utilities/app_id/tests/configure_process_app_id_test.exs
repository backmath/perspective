defmodule Perspective.ConfigureProcessAppId.Test do
  use ExUnit.Case, async: true

  test "accepts list with an :app_id and stores as an atom" do
    Perspective.ConfigureProcessAppId.configure(app_id: "some-app-id.perpsective")

    app_id =
      Process.info(self())
      |> Keyword.get(:dictionary)
      |> Keyword.get(:app_id)

    assert app_id == :"some-app-id.perpsective"
  end

  test "accepts a map with an :app_id and stores as an atom" do
    Perspective.ConfigureProcessAppId.configure(%{app_id: "some-app-id.perpsective"})

    app_id =
      Process.info(self())
      |> Keyword.get(:dictionary)
      |> Keyword.get(:app_id)

    assert app_id == :"some-app-id.perpsective"
  end

  test "fetching the app_id will return the same as string" do
    Perspective.ConfigureProcessAppId.configure(app_id: "some-app-id.perpsective")

    app_id = Perspective.FetchProcessAppId.fetch()

    assert app_id == "some-app-id.perpsective"
  end

  test "a missing configuration raises an error" do
    old_env = Application.get_env(:perspective, Perspective.Application)

    Application.put_env(:perspective, Perspective.Application, [])

    assert_raise(Perspective.MissingAppIdConfiguration, fn ->
      Perspective.ConfigureProcessAppId.configure([])
    end)

    Application.put_env(:perspective, Perspective.Application, old_env)
  end

  test "configure() returns the configured app_id" do
    app_id = Perspective.ConfigureProcessAppId.configure(app_id: "some-app-id.perpsective")

    assert app_id == "some-app-id.perpsective"
  end
end
