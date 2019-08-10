defmodule Perspective.Server.Test do
  use ExUnit.Case

  test "a generated server name prepends app_id to a module name" do
    assert {:global, "com.app.id.MyModule"} == Perspective.Server.name(MyModule, "com.app.id")
  end

  test "a generated server name with an app_id as a keyword argument" do
    assert {:global, "com.app.id.MyModule"} == Perspective.Server.name(MyModule, app_id: "com.app.id")
  end

  test "a generated server name with a nil/empty app_id simply returns the stringed module name" do
    assert {:global, "MyModule"} == Perspective.Server.name(MyModule, nil)
  end

  test "a generated server name with an nil/empty app_id simply returns the stringed module name" do
    assert {:global, "MyModule"} == Perspective.Server.name(MyModule, "")
  end

  test "a generated server name without a provided app_id simply returns the stringed module name" do
    assert {:global, "MyModule"} == Perspective.Server.name(MyModule)
  end
end
