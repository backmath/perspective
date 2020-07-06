defmodule Perspective.IdentifierMacro.Test do
  use Perspective.TestCase

  defmodule DefaultExample do
    use Perspective.IdentifierMacro
  end

  defmodule UsageExample do
    use Perspective.IdentifierMacro

    path([id: id]) do
      "usage-example/#{id}"
    end
  end

  test "using Perspective.IdentifierMacro installs path/0, defaulting to the module's name" do
    assert "Perspective.IdentifierMacro.Test.DefaultExample" == DefaultExample.path()
  end

  test "using Perspective.IdentifierMacro installs uri/0, defaulting to the module's appID-based URI", %{app_id: app_id} do
    assert "#{app_id}/Perspective.IdentifierMacro.Test.DefaultExample" == DefaultExample.uri()
  end

  test "using Perspective.IdentifierMacro installs name/0, defaulting to a globally-addressed uri", %{app_id: app_id} do
    assert {:global, "#{app_id}/Perspective.IdentifierMacro.Test.DefaultExample"} == DefaultExample.name()
  end

  test "calling IdentifierMacro.path(state) installs path/1" do
    assert "usage-example/abc" == UsageExample.path([id: "abc"])
  end

  test "calling IdentifierMacro.path(state) installs uri/1", %{app_id: app_id} do
    assert "#{app_id}/usage-example/abc" == UsageExample.uri([id: "abc"])
  end

  test "calling IdentifierMacro.path(state) installs name/1", %{app_id: app_id} do
    assert {:global, "#{app_id}/usage-example/abc"} == UsageExample.name([id: "abc"])
  end
end
