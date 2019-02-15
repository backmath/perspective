defmodule Perspective.ModuleRegistry.Test do
  use ExUnit.Case

  test "a compiled module using the registry can be discovered" do
    assert [Perspective.ModuleRegistry.Test.Example] =
             Perspective.ModuleRegistry.list(Perspective.ModuleRegistry.Test.Some.Namespace)
  end
end
