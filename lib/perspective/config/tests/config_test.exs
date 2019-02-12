defmodule Perspective.Config.Test do
  use ExUnit.Case
  use Perspective.Config

  test "use Perspective.Config gives access to application configuration" do
    assert :expected_value == config(:test_config)
  end
end
