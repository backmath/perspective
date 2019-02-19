defmodule Perspective.Projection.Test do
  use ExUnit.Case

  defmodule Example do
    use Perspective.Projection
    expose("something", Something)
  end

  test "projections generate a channel" do
    assert "something" == Example.Channel.path()
    assert [Core.System.SystemTime.Channel] == Perspective.ModuleRegistry.list(Perspective.ProjectionChannel)
  end
end
