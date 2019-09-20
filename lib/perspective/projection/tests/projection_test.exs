defmodule Perspective.Projection.Test do
  use ExUnit.Case, async: true

  test "projections generate a channel" do
    # @todo be more complete
    assert "/something" === Something.ProjectionController.path()
  end
end
