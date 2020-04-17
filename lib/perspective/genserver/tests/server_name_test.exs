defmodule Perspective.ServerName.Test do
  use ExUnit.Case, async: true

  setup do
    Process.put(:app_id, nil)
    :ok
  end

  test "a generated server name without configured app_id simply returns the stringed module name" do
    result = Perspective.ServerName.name(MyModule)

    assert result == {:global, "MyModule"}
  end

  test "a generated server name with a configured app_id prepends app_id to a module name" do
    Process.put(:app_id, "com.app.set")
    result = Perspective.ServerName.name(MyModule)

    assert result == {:global, "com.app.set.MyModule"}
  end

  test "a generated server name with an empty app_id simply returns the stringed module name" do
    result = Perspective.ServerName.name(MyModule, "")

    assert result == {:global, "MyModule"}
  end

  test "a generated server name with a nil app_id simply returns the stringed module name" do
    result = Perspective.ServerName.name(MyModule, nil)

    assert result == {:global, "MyModule"}
  end

  test "a generated server name prepends app_id to a module name" do
    result = Perspective.ServerName.name(MyModule, "com.app.id")

    assert result == {:global, "com.app.id.MyModule"}
  end

  test "a generated server name with an app_id as a keyword argument" do
    result = Perspective.ServerName.name(MyModule, app_id: "com.app.id")

    assert result == {:global, "com.app.id.MyModule"}
  end

  test "a generated server name with an provided name takes precedence over module name" do
    result = Perspective.ServerName.name(MyModule, app_id: "com.app.id", name: "SomethingElse")

    assert result == {:global, "com.app.id.SomethingElse"}
  end

  test "a generated server name can receive a full keyword list" do
    opts = [
      app_id: "com.app.id",
      something: :else
    ]

    result = Perspective.ServerName.name(MyModule, opts)

    assert result == {:global, "com.app.id.MyModule"}
  end

  test "a generated server name can receive a map" do
    opts = %{
      app_id: "com.app.id",
      something: :else
    }

    result = Perspective.ServerName.name(MyModule, opts)

    assert result == {:global, "com.app.id.MyModule"}
  end
end
