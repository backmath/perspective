defmodule Perspective.Config.Test do
  use ExUnit.Case
  use Perspective.Config

  defmodule Example do
    use Perspective.Config

    def a, do: config(:test_config)
    def b, do: config(:absent_config, :another_value)
  end

  defmodule ExampleOverride do
    use Perspective.Config, Perspective.Config.Test.SpecialOverride

    def a, do: config(:test_config)
    def b, do: config(:absent_config, :another_value)
  end

  test "use Perspective.Config gives access to application configuration" do
    assert :expected_value == Example.a()
    assert :another_value == Example.b()
  end

  test "use Perspective.Config can use different module names" do
    assert :expected_value == ExampleOverride.a()
    assert :another_value == ExampleOverride.b()
  end
end
