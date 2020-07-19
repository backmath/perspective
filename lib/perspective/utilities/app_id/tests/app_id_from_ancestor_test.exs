defmodule Perspective.AppIdFromAncestor.Test do
  use ExUnit.Case, async: true

  defmodule ExampleSubProcess do
    use Agent

    def start_link(_) do
      Agent.start_link(fn -> nil end)
    end
  end

  test "a process without ancestors returns nil" do
    app_id = Perspective.AppIdFromAncestor.find(self())

    assert nil == app_id
  end

  test "a process with an ancestor without an :app_id returns nil (remember, this is an $ancestral lookup)" do
    new_proess = start_supervised!(ExampleSubProcess)

    app_id = Perspective.AppIdFromAncestor.find(new_proess)

    assert nil == app_id
  end

  test "a process with an ancestor having :app_id returns that id" do
    Process.put(:app_id, "some-app-id")

    new_proess = start_supervised!(ExampleSubProcess)

    app_id = Perspective.AppIdFromAncestor.find(new_proess)

    assert "some-app-id" == app_id
  end
end
