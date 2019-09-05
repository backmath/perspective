defmodule Perspective.ChildrenSpecs.Test do
  use ExUnit.Case, async: true

  test "calling set_app_id with single module returns the desired tuple" do
    result = Perspective.ChildrenSpecs.set_app_id(SomeModule, "com.perspectivelib")

    assert result == {SomeModule, [app_id: "com.perspectivelib"]}
  end

  test "calling set_app_id with a tuple will add an arguments list" do
    result = Perspective.ChildrenSpecs.set_app_id({SomeModule}, "com.perspectivelib")

    assert result == {SomeModule, [app_id: "com.perspectivelib"]}
  end

  test "calling set_app_id with a tuple will update an arguments list" do
    result = Perspective.ChildrenSpecs.set_app_id({SomeModule, some: :keyword}, "com.perspectivelib")

    assert result == {SomeModule, [app_id: "com.perspectivelib", some: :keyword]}
  end

  test "calling set_app_id upon a list will map set_app_id" do
    result = Perspective.ChildrenSpecs.set_app_id([SomeModule], "com.perspectivelib")

    assert result == [{SomeModule, [app_id: "com.perspectivelib"]}]
  end
end
