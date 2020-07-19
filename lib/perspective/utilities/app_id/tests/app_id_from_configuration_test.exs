defmodule Perspective.AppIdFromConfiguration.Test do
  use ExUnit.Case, async: true

  test "looks up configured app_id correctly" do
    app_id = Perspective.AppIdFromConfiguration.find()

    assert app_id == "test.perspective.com"
  end

  test "a missing configuration returns nil" do
    old_env = Application.get_env(:perspective, Perspective.Application)

    Application.put_env(:perspective, Perspective.Application, [])

    assert nil == Perspective.AppIdFromConfiguration.find()

    Application.put_env(:perspective, Perspective.Application, old_env)
  end
end
