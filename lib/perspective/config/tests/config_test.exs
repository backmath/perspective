defmodule Perspective.Config.Test do
  use ExUnit.Case, async: true

  defmodule Example do
    use Perspective.Config

    def test_config, do: config(:test_config)
    def absent_config, do: config(:absent_config)
  end

  defmodule ExampleOverride do
    use Perspective.Config, Perspective.Config.Test.SpecialOverride

    def test_config, do: config(:test_config)
    def absent_config, do: config(:absent_config)
  end

  defmodule MissingAllTogether do
    use Perspective.Config

    def absent_config, do: config(:absent_config_alltogether)
  end

  test "calling Perspective.Config.config expects the key to exists" do
    assert_raise Perspective.Config.MissingOptionKey, fn ->
      Example.absent_config()
    end

    assert_raise Perspective.Config.MissingOptionKey, fn ->
      ExampleOverride.absent_config()
    end

    assert_raise Perspective.Config.MissingOptionKey, fn ->
      MissingAllTogether.absent_config()
    end
  end

  test "calling Perspective.Config.config returns expected values" do
    assert :expected_value = Example.test_config()

    assert :expected_value = ExampleOverride.test_config()
  end
end
