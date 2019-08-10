defmodule Perspective.Supervisor.Test do
  use ExUnit.Case

  defmodule Example do
    use Perspective.Supervisor
  end

  test "a supervisor automatically sets up the name" do
    Perspective.Supervisor.Test.Example.start_link(app_id: "com.app.id")

    assert [] = Supervisor.which_children({:global, "com.app.id.Perspective.Supervisor.Test.Example"})
  end

  test "a supervisor started without an app_id simply uses its own stringed name" do
    Perspective.Supervisor.Test.Example.start_link(:ok)

    assert [] = Supervisor.which_children({:global, "Perspective.Supervisor.Test.Example"})
  end
end
